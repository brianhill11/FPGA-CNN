#include <aalsdk/utils/Utilities.h>       // Brings in CL, MB, GB, etc.
#include <aalsdk/utils/CSyncClient.h>     // CSyncClient object
#include <aalsdk/service/ISPLAFU.h>       // Service Interface
#include <aalsdk/service/SPLAFUService.h> // Service Manifest and #defines
#include <aalsdk/service/ISPLClient.h>    // Service Client Interface
#include <aalsdk/kernel/vafu2defs.h>      // AFU structure definitions (brings in spl2defs.h)
#include <aalsdk/AALLoggerExtern.h>       // Logger, used by INFO and ERR macros
#include <aalsdk/aalclp/aalclp.h>         // Command-line processor

#define DEFAULT_TARGET_AFU SPLAFU_NVS_VAL_TARGET_FPGA
#define POLL_INTERVAL 100

class AFU : public CSyncClient,        // Inherit interface and implementation of IRunTimeClien and IServiceClient
            public ISPLClient          // SPL Client Interface
{
public:
  AFU(btWSSize dsm_size, btWSSize ws_size, bool debug=false) :
    m_pISPLAFU(NULL),
    m_pServiceBase(NULL),
    m_OneLargeWorkspaceVirt(NULL),
    m_OneLargeWorkspaceSize(0),
    m_AFUDSMVirt(NULL),
    m_AFUDSMSize(dsm_size),
    m_AFUTarget(DEFAULT_TARGET_AFU),
    m_WSRequestLen(0),
    m_Manifest(SPLAFU_MANIFEST),
    m_debug(debug)
  {

    // enable debug messages
    if (debug) {
      pAALLogger()->AddToMask(LM_All, 7);
      pAALLogger()->SetDestination(ILogger::COUT);
    }

    m_usingASE = false;

    // use ASE if ASE_WORKDIR environment var is defined
    if (getenv("ASE_WORKDIR")) {
      AFUTarget(std::string(SPLAFU_NVS_VAL_TARGET_ASE));
      m_usingASE = true;
    }
     
    SetSubClassInterface(iidSPLClient, dynamic_cast<ISPLClient *>(this));

    // define Runtime parameters
    if ( (0 == AFUTarget().compare(SPLAFU_NVS_VAL_TARGET_ASE)) ||
         (0 == AFUTarget().compare(SPLAFU_NVS_VAL_TARGET_SWSIM)) ) {
      m_RuntimeArgs.Add(SYSINIT_KEY_SYSTEM_NOKERNEL, true);
    } else {
      NamedValueSet ConfigRecord;
      ConfigRecord.Add(XLRUNTIME_CONFIG_BROKER_SERVICE, "librrmbroker");
      m_RuntimeArgs.Add(XLRUNTIME_CONFIG_RECORD, ConfigRecord);
    }

    // define the Manifest
    btcString AFUName = "SPLAFU";
    m_Manifest.Add(AAL_FACTORY_CREATE_SERVICENAME, AFUName);
    m_Manifest.Add(SPLAFU_NVS_KEY_TARGET, AFUTarget().c_str());

    // start Runtime and Service
    m_bIsOK = start();

    if (m_bIsOK) {
      // allocate workspace
      syncWorkspaceAllocate(ws_size, TransactionID());

      // acquire AFU and Transaction context
      syncStartTransactionContext(TransactionID(), OneLargeVirt(), POLL_INTERVAL);
    }
  }
  
  ~AFU() {
    INFO("Stopping SPL Transaction");
    syncStopTransactionContext( TransactionID() );
    INFO("Workspace verification complete, freeing workspace.");
    syncWorkspaceFree(OneLargeVirt(), TransactionID());
    
    INFO("Releasing the SPL Service");
    syncRelease(TransactionID());
    
    INFO("Stopping the XL Runtime");
    stop();
  }
  
  btBool IsOK() const { return m_bIsOK && CSyncClient::IsOK(); }

  ///////////////////////////////////////////////////////////////////////////
  // <Extend CSyncClient>
  // First call to AFU. Start everything up and then return status.
  // If returns false, need to shut down the runtime and exit.
  bool start()
  {
    if ( !syncStart( m_RuntimeArgs ) ) { // CSyncClient synchronous runtime start
      ERR("Could not start Runtime.");
      return false;
    }

    m_pServiceBase = syncAllocService( m_Manifest );  // CSyncClient synchronous get pointer
    if ( !m_pServiceBase ) {                        //    to Service Object
      ERR("Could not allocate Service.");          // Error return possible if it cannot
      return false;                                //    be obtained
    }

    // Get pointer to SPL AFU
    m_pISPLAFU = dynamic_ptr<ISPLAFU>( iidSPLAFU, m_pServiceBase);
    ASSERT( m_pISPLAFU );
    if ( !m_pISPLAFU ) {                         // this would represent an internal logic error
      ERR( "Could not access SPL Service.");
      return false;
    }
    return m_bIsOK;
  }
  // Shutdown the RunTime Client, and therefore the RunTime itself
  void stop()
  {
    syncStop();    // use CSyncClient's synchronouse stop
  }

  bool is_simulation() {
    return m_usingASE;
  }

  inline volatile int read_dsm(uint32_t offset) {
    return *(volatile int *)(m_AFUDSMVirt + offset);
  }

  // inline volatile uint32_t read_dsm(uint32_t offset) {
  //   return *(volatile uint32_t *)(m_AFUDSMVirt + offset);
  // }

  inline btBool write_csr(btCSROffset CSR, btCSRValue Value)
  {
    // 2015/02/25: GSP: 0xfff address mask is needed to work around an issue
    if (!m_usingASE) {
      CSR = (CSR & 0xfff) / 4;
    }
    return m_pISPLAFU->CSRWrite( CSR, Value);
  }

  inline btBool write_csr_64(btCSROffset CSR, bt64bitCSR Value)
  {
    // 2015/02/25: GSP: 0xfff address mask is needed to work around an issue
    if (!m_usingASE) {
      CSR = (CSR & 0xfff) / 4;
    }
    return m_pISPLAFU->CSRWrite64( CSR, Value);
  }

  btBool is_ready() {
    return IsOK();
  }

  inline long time_diff_ns() {
    long now_ns = gettime_in_ns();
    long time_diff = now_ns - prev_time_ns;
    prev_time_ns = now_ns;
    return time_diff;
  }

  inline long gettime_in_ns() {
    struct timespec now;
    clock_gettime(CLOCK_REALTIME, &now);
    return now.tv_sec * 1e9 + now.tv_nsec;
  }

  
  // </Extend CSyncClient>
  ///////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////
  // <ISPLClient>

  /// AFU Client implementation of ISPLClient::OnWorkspaceAllocated
  virtual void OnWorkspaceAllocated( TransactionID const &TranID,
                                     btVirtAddr           WkspcVirt,
                                     btPhysAddr           WkspcPhys,
                                     btWSSize             WkspcSize)
  {
    OneLarge(WkspcVirt, WkspcPhys, WkspcSize);
    INFO("Got Workspace");
    Post();
  }
  /// AFU Client implementation of ISPLClient::OnWorkspaceAllocateFailed
  virtual void OnWorkspaceAllocateFailed( const IEvent &Event)
  {
    m_bIsOK = false;
    OneLarge( NULL, 0, 0);
    ERR("Workspace Allocate Failed");
    Post();
  }
  /// AFU Client implementation of ISPLClient::OnWorkspaceFreed
  virtual void OnWorkspaceFreed( TransactionID const &TranID)
  {
    OneLarge( NULL, 0, 0);
    INFO("Freed Workspace");
    Post();
  }
  /// AFU Client implementation of ISPLClient::OnWorkspaceFreeFailed
  virtual void OnWorkspaceFreeFailed( const IEvent &Event)
  {
    m_bIsOK = false;
    OneLarge( NULL, 0, 0);
    ERR("Workspace Free Failed");
    Post();
  }
  /// AFU Client implementation of ISPLClient::OnTransactionStarted
  virtual void OnTransactionStarted( TransactionID const &TranID,
                                     btVirtAddr           AFUDSMVirt,
                                     btWSSize             AFUDSMSize)
  {
    INFO("Transaction Started");
    printf("DSM size = %d\n", AFUDSMSize);
    AFUDSM(AFUDSMVirt, AFUDSMSize);
    Post();
  }
  /// AFU Client implementation of ISPLClient::OnContextWorkspaceSet
  virtual void OnContextWorkspaceSet( TransactionID const &TranID)
  {
    INFO("Context Set");
    Post();
  }
  /// AFU Client implementation of ISPLClient::OnTransactionFailed
  virtual void OnTransactionFailed( const IEvent &Event)
  {
    m_bIsOK = false;
    AFUDSM( NULL, 0);
    ERR("Transaction Failed");
    Post();
  }
  /// AFU Client implementation of ISPLClient::OnTransactionComplete
  virtual void OnTransactionComplete( TransactionID const &TranID)
  {
    AFUDSM( NULL, 0);
    INFO("Transaction Complete");
    Post();
  }
  /// AFU Client implementation of ISPLClient::OnTransactionStopped
  virtual void OnTransactionStopped( TransactionID const &TranID)
  {
    AFUDSM( NULL, 0);
    INFO("Transaction Stopped");
    Post();
  }
  // </ISPLClient>
  ///////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////
  // <Synchronous versions of ISPLAFU (which includes ICCIAFU>

  /// AFU Client synchronous implementation of ISPLAFU::StartTransactionContext
  btBool syncStartTransactionContext(TransactionID const &TranID,
                                     btVirtAddr           Address=NULL,
                                     btTime               Pollrate=0)
  {
    m_pISPLAFU->StartTransactionContext( TranID, Address, Pollrate);
    Wait();                    // Posted in OnTransactionStarted()
    return m_bIsOK;
  }
  /// AFU Client synchronous implementation of ISPLAFU::StopTransactionContext
  btBool syncStopTransactionContext(TransactionID const &TranID)
  {
    m_pISPLAFU->StopTransactionContext( TranID);
    Wait();
    return m_bIsOK;
  }
  /// AFU Client synchronous implementation of ISPLAFU::SetContextWorkspace
  btBool syncSetContextWorkspace(TransactionID const &TranID,
                                 btVirtAddr           Address,
                                 btTime               Pollrate=0)
  {
    m_pISPLAFU->SetContextWorkspace( TranID, Address, Pollrate);
    Wait();
    return m_bIsOK;
  }
  /// AFU Client synchronous implementation of ISPLAFU::WorkspaceAllocate
  btBool syncWorkspaceAllocate(btWSSize             Length,
                               TransactionID const &rTranID)
  {
    m_pISPLAFU->WorkspaceAllocate( Length, rTranID);
    Wait();
    return m_bIsOK;
  }
  /// AFU Client synchronous implementation of ISPLAFU::WorkspaceFree
  btBool syncWorkspaceFree(btVirtAddr           Address,
                           TransactionID const &rTranID)
  {
    m_pISPLAFU->WorkspaceFree( Address, rTranID);
    Wait();
    return m_bIsOK;
  }

  // These are already synchronous, but this object is not derived from
  //    ICCIAFU, so must delegate

  /// AFU Client delegation of ICCIAFU::CSRRead
  btBool CSRRead(btCSROffset CSR, btCSRValue *pValue)
  {
    return m_pISPLAFU->CSRRead( CSR, pValue);
  }
  /// AFU Client delegation of ICCIAFU::CSRWrite
  btBool CSRWrite(btCSROffset CSR, btCSRValue Value)
  {
    return m_pISPLAFU->CSRWrite( CSR, Value);
  }
  /// AFU Client delegation of ICCIAFU::CSRWrite64
  btBool CSRWrite64(btCSROffset CSR, bt64bitCSR Value)
  {
    return m_pISPLAFU->CSRWrite64( CSR, Value);
  }
  // </Synchronous versions of ISPLAFU (which includes ICCIAFU>
  ///////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////////////////////////////////
  // Accessors and Mutators

  btVirtAddr OneLargeVirt() const { return m_OneLargeWorkspaceVirt; } ///< Accessor for the AFU Context workspace.
  btWSSize   OneLargeSize() const { return m_OneLargeWorkspaceSize; } ///< Accessor for the AFU Context workspace.

  btVirtAddr AFUDSMVirt()   const { return m_AFUDSMVirt; } ///< Accessor for the AFU DSM workspace.
  btWSSize   AFUDSMSize()   const { return m_AFUDSMSize; } ///< Accessor for the AFU DSM workspace.

  /// Mutator for setting the NVS value that selects the AFU Delegate.
  void AFUTarget(const std::string &target) { m_AFUTarget = target;  }
  /// Accessor for the NVS value that selects the AFU Delegate.
  std::string AFUTarget() const             { return m_AFUTarget;    }

  /// Mutator for setting the AFU Context workspace size.
  void WSRequestLen(btWSSize len)           { m_WSRequestLen = len;  }
  /// Accessor for the AFU Context workspace size.
  btWSSize WSRequestLen() const             { return m_WSRequestLen; }

protected:
  /// Store information about the Virtual Workspace into AFU
  void OneLarge(btVirtAddr v, btPhysAddr p, btWSSize s)
  {
    m_OneLargeWorkspaceVirt = v;
    m_OneLargeWorkspaceSize = s;
  }
  /// Store information about the DSM (Device Status Memory) into AFU
  void AFUDSM(btVirtAddr v, btWSSize s)
  {
    m_AFUDSMVirt = v;
    m_AFUDSMSize = s;
  }

  // Member variables
  AAL::ISPLAFU        *m_pISPLAFU;       ///< Points to the actual AFU, stored here for convenience
  AAL::IBase          *m_pServiceBase;   ///< Pointer to Service containing SPL AFU

  btVirtAddr           m_OneLargeWorkspaceVirt; ///< Points to Virtual workspace
  btWSSize             m_OneLargeWorkspaceSize; ///< Length in bytes of Virtual workspace
  btVirtAddr           m_AFUDSMVirt;            ///< Points to DSM
  btWSSize             m_AFUDSMSize;            ///< Length in bytes of DSM

  std::string          m_AFUTarget;      ///< The NVS value used to select the AFU Delegate (FPGA, ASE, or SWSim).
  btWSSize             m_WSRequestLen;   ///< Requested size of the AFU Context workspace in bytes.

  NamedValueSet        m_RuntimeArgs;    ///< Parameters used to initialize the Runtime
  NamedValueSet        m_Manifest;       ///< Manifest selects the Service to be obtained

  bool                 m_debug;     ///< debug flag
  bool                 m_usingASE;  ///< true if connected to ASE
  long prev_time_ns;
};


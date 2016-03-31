#!/bin/bash
#########################################################
#
# Script to install Caffe dependencies 
# 
# For each dependency we download the source and compile,
# and then add the path to the binaries/libraries to 
# our .bashrc and .cshrc, as well as the path to the 
# header files and libraries to our Caffe Makefile.config
#########################################################
BASE=$PWD
NUM_CORES=`nproc`

# YUM deps needed to clone git repos
#sudo yum install git
# YUM deps needed for protobuf
#sudo yum install -y autoconf automake libtool gcc-c++
# YUM deps needed for hdf5
#sudo yum install -y zlib zlib-devel

##############################################
##### download Caffe
##############################################
git clone https://github.com/BVLC/caffe.git 
cd caffe
cp Makefile.config.example Makefile.config
CAFFE_CONFIG=$BASE/caffe/Makefile.config
echo '# Automatically generated statements' >> $CAFFE_CONFIG

##############################################
##### Install Depdendencies
##############################################
# create dependencies dir if not exist
mkdir -p $BASE/dependencies

##############################################
##### install boost 1.59.0
##############################################
cd $BASE/dependencies
mkdir -p boost
cd boost
wget http://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.gz
tar -zxvf boost_1_59_0.tar.gz
cd boost_1_59_0
./bootstrap.sh --prefix=${PWD}
./b2 install -j${NUM_CORES}

echo "export LD_LIBRARY_PATH=\"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.bashrc
echo "export PATH=\"${PWD}/bin:"'${PATH}"' >> ~/.bashrc
echo "setenv LD_LIBRARY_PATH \"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.cshrc
echo "setenv PATH \"${PWD}/bin:"'${PATH}"' >> ~/.csshrc
echo "INCLUDE_DIRS += ${PWD}/include" >> $CAFFE_CONFIG
echo "LIBRARY_DIRS += ${PWD}/lib" >> $CAFFE_CONFIG

##############################################
##### install protobuf
##############################################
cd $BASE/dependencies
# build protobuf
git clone https://github.com/google/protobuf.git
cd protobuf
./autogen.sh
./configure --prefix=${PWD} && make -j${NUM_CORES} && make install

echo "export LD_LIBRARY_PATH=\"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.bashrc
echo "export PATH=\"${PWD}/bin:"'${PATH}"' >> ~/.bashrc
echo "setenv LD_LIBRARY_PATH \"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.cshrc
echo "setenv PATH \"${PWD}/bin:"'${PATH}"' >> ~/.csshrc
echo "INCLUDE_DIRS += ${PWD}/include" >> $CAFFE_CONFIG
echo "LIBRARY_DIRS += ${PWD}/lib" >> $CAFFE_CONFIG

##############################################
##### install snappy
##############################################
cd $BASE/dependencies
mkdir -p snappy
cd snappy
wget https://snappy.googlecode.com/files/snappy-1.1.1.tar.gz
tar -xzvf snappy-1.1.1.tar.gz
cd snappy-1.1.1
./configure --prefix=${PWD} && make -j${NUM_CORES} && make install

echo "export LD_LIBRARY_PATH=\"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.bashrc
echo "export PATH=\"${PWD}/bin:"'${PATH}"' >> ~/.bashrc
echo "setenv LD_LIBRARY_PATH \"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.cshrc
echo "setenv PATH \"${PWD}/bin:"'${PATH}"' >> ~/.csshrc
echo "INCLUDE_DIRS += ${PWD}/include" >> $CAFFE_CONFIG
echo "LIBRARY_DIRS += ${PWD}/lib" >> $CAFFE_CONFIG

##############################################
##### install gflags
##############################################
cd $BASE/dependencies
mkdir -p gflags
cd gflags
wget https://gflags.googlecode.com/files/gflags-2.0-no-svn-files.tar.gz
tar -xzvf gflags-2.0-no-svn-files.tar.gz
cd gflags-2.0
./configure --prefix=${PWD} && make -j${NUM_CORES} && make install

echo "export LD_LIBRARY_PATH=\"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.bashrc
echo "export PATH=\"${PWD}/bin:"'${PATH}"' >> ~/.bashrc
echo "setenv LD_LIBRARY_PATH \"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.cshrc
echo "setenv PATH \"${PWD}/bin:"'${PATH}"' >> ~/.csshrc
echo "INCLUDE_DIRS += ${PWD}/include" >> $CAFFE_CONFIG
echo "LIBRARY_DIRS += ${PWD}/lib" >> $CAFFE_CONFIG

##############################################
###### install glog
##############################################
cd $BASE/dependencies
mkdir -p glog
cd glog
wget https://google-glog.googlecode.com/files/glog-0.3.3.tar.gz
tar zxvf glog-0.3.3.tar.gz
cd glog-0.3.3
./configure --prefix=${PWD} && make -j${NUM_CORES} && make install

echo "export LD_LIBRARY_PATH=\"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.bashrc
echo "export PATH=\"${PWD}/bin:"'${PATH}"' >> ~/.bashrc
echo "setenv LD_LIBRARY_PATH \"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.cshrc
echo "setenv PATH \"${PWD}/bin:"'${PATH}"' >> ~/.csshrc
echo "INCLUDE_DIRS += ${PWD}/include" >> $CAFFE_CONFIG
echo "LIBRARY_DIRS += ${PWD}/lib" >> $CAFFE_CONFIG

##### install lmdb
cd $BASE/dependencies
git clone https://github.com/LMDB/lmdb
cd lmdb/libraries/liblmdb
sed -i 's_/usr/local_._g' Makefile 
make -j${NUM_CORES} && make install

echo "export LD_LIBRARY_PATH=\"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.bashrc
echo "export PATH=\"${PWD}/bin:"'${PATH}"' >> ~/.bashrc
echo "setenv LD_LIBRARY_PATH \"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.cshrc
echo "setenv PATH \"${PWD}/bin:"'${PATH}"' >> ~/.csshrc
echo "INCLUDE_DIRS += ${PWD}/include" >> $CAFFE_CONFIG
echo "LIBRARY_DIRS += ${PWD}/lib" >> $CAFFE_CONFIG

##############################################
##### install hdf5
##############################################
cd $BASE/dependencies
mkdir -p hdf5
cd hdf5
wget http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.16.tar.gz
tar -zxvf hdf5-1.8.16.tar.gz 
cd hdf5-1.8.16
./configure --prefix=${PWD} && make -j${NUM_CORES} && make install

echo "export LD_LIBRARY_PATH=\"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.bashrc
echo "export PATH=\"${PWD}/bin:"'${PATH}"' >> ~/.bashrc
echo "setenv LD_LIBRARY_PATH \"${PWD}/lib:"'${LD_LIBRARY_PATH}"' >> ~/.cshrc
echo "setenv PATH \"${PWD}/bin:"'${PATH}"' >> ~/.csshrc
echo "LIBRARY_DIRS += ${PWD}/lib" >> $CAFFE_CONFIG
echo "INCLUDE_DIRS += ${PWD}/include" >> $CAFFE_CONFIG

echo 
echo "########################################################"
echo "Please source your ~/.bashrc file and/or ~/.cshrc file"
echo "i.e.: source ~/.bashrc "
echo "########################################################"


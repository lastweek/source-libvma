#!/bin/bash

BASE_DIR=`pwd`
script_dir=`dirname $(readlink -f $0)`
cd $script_dir/..

LOG_FILE=`pwd`/build_rpm.log

echo "Running ./autogen.sh ..."
./autogen.sh > $LOG_FILE 2>&1

echo "Running ./configure ..."
./configure >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
	echo "configure failed! see $LOG_FILE"
	cd $BASE_DIR
	exit
fi

echo "Running make dist ..."
make dist >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
	echo "make dist failed! see $LOG_FILE"
	cd $BASE_DIR
	exit
fi

echo "Running rpmbuild ... this might take a while ..."
rpmbuild -ta libvma*.tar.gz >> $LOG_FILE 2>&1
if [ $? -ne 0 ]; then
	echo "rpmbuild failed! see $LOG_FILE"
	cd $BASE_DIR
	exit
fi

grep Wrote build_rpm.log
rm -rf $LOG_FILE

cd $BASE_DIR

#!/usr/bin/env bash

yum -y install gcc gcc-c++ libtool zlib-devel openssl-devel ncurses-devel autoconf213 perl wget


erlpackage="otp_src_R16B03-1"
cd /vagrant/
if [ ! -e $erlpackage ]; then
	echo "download it"
	wget http://www.erlang.org/download/$erlpackage.tar.gz
	zcat $erlpackage.tar.gz | tar xf -
fi
cd $erlpackage
echo "manually compiling in" `pwd`
./configure --enable-kernel-poll --enable-threads --enable-dynamic-ssl-lib --enable-shared-zlib --enable-smp-support
#   **********************  APPLICATIONS DISABLED  **********************
#   jinterface     : No Java compiler found
#   odbc           : ODBC library - link check failed
#   **********************  APPLICATIONS INFORMATION  *******************
#   wx             : wxWidgets not found, wx will NOT be usable
#   **********************  DOCUMENTATION INFORMATION  ******************
#   documentation  :
#                    xsltproc is missing.
#                    fop is missing.
#                    The documentation can not be built.
#   ********************************************************************* 
make
make install
cd ../





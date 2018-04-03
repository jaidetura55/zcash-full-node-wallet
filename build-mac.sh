#!/bin/bash

############################################
#    Created by @Pega88 && @Jon_S_Layton   #
#         v1.0.0-rc1 16 Feb 2018		   	   #
############################################

echo "***************************"
echo "|| Checking dependencies ||"
echo "***************************"
echo ""

#fetch + install jar2app
if [ -e /usr/local/bin/jar2app ]
then
    echo "jar2app already installed - OK"
else
	git clone https://github.com/Jorl17/jar2app
	cd jar2app
	chmod +x install.sh uninstall.sh
	sudo ./install.sh /usr/local/bin
  cd ..
  rm -rf jar2app
fi

#fetch + install dylibbundler 
if [ -e /usr/local/bin/dylibbundler ]
then
    echo "dylibbundler already installed - OK"
else
	git clone https://github.com/auriamg/macdylibbundler
	cd macdylibbundler 
	sudo make install
  cd ..
  rm -rf macdylibbundler 
fi

echo ""
echo "******************"
echo "|| building JAR ||"
echo "******************"
echo ""

#build the jar from source
ant jar -f src/build/build.xml

echo ""
echo "*******************"
echo "|| Packaging App ||"
echo "*******************"
echo ""
#package jar to app
jar2app build/jars/ZcashSwingWallet.jar -n ZcashDesktopWallet  -i ./src/resources/images/zcash-logo.icns

echo ""
echo "**********************************"
echo "|| Statically linking libraries ||"
echo "**********************************"
echo ""

#statically build required libraries
dylibbundler -od -b -d ./ZcashDesktopWallet.app/Contents/libs \
                    -p @executable_path/libs

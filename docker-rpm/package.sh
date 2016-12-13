#!/bin/bash
# pass build number in as first arg and branch as second arg
# usage:
#  ./package.sh 15 feature/coolfeature

# set path to downloaded source
BRANCH=$2
SRCPATH=/tmp/source/cl-merchant_cleaning/

# make sure source has correct branch and is up to date
pushd $SRCPATH
git checkout $BRANCH
git pull origin $BRANCH

# bump versions here for RPM package output
MAJVER=2
MINVER=0
BUILDNUM=$1
VER=$MAJVER.$MINVER.$BUILDNUM

# build the base rpmbuild directory using the setuptree command
rpmdev-setuptree

# set paths to rpmbuild directories
APPPATH=/root/rpmbuild/SOURCES/mce-$VER/opt/mce/
BINPATH=/root/rpmbuild/SOURCES/mce-$VER/usr/local/bin/

# make sure directories exist
mkdir -p $APPPATH
mkdir -p $BINPATH

# download the jars from artifactory and add assembly to their filename (not sure why but mce.spec insists)
wget https://artifacts.company.com/artifactory/cdl-output-mce-jar/mce/mce/$VER/mce-$VER-assembly.jar -O $APPPATH/mce-assembly-$VER.jar
wget https://artifacts.company.com/artifactory/cdl-output-mce-jar/mce-parser/mce-parser/$VER/mce-parser-$VER-assembly.jar -O $APPPATH/mce-parser-assembly-$VER.jar


cp $SRCPATH/packaging/testdata/test.tsv $APPPATH
cp $SRCPATH/packaging/log4j.properties $APPPATH
cp $SRCPATH/packaging/mce.conf $APPPATH
cp $SRCPATH/mce/SPEC/mce.spec /root/rpmbuild/SPECS/mce.spec

cp $SRCPATH/mce/sbin/{mce,mcefix} $BINPATH

# search and replace in mce.spec file to set versioning
sed -i "s/\[TOKEN_MAJVER\]/$MAJVER/g" /root/rpmbuild/SPECS/mce.spec
sed -i "s/\[TOKEN_MINVER\]/$MINVER/g" /root/rpmbuild/SPECS/mce.spec
sed -i "s/\[TOKEN_RELEASE\]/$BUILDNUM/g" /root/rpmbuild/SPECS/mce.spec

# tar and gzip the dir for rpm packaging target
pushd /root/rpmbuild/SOURCES/
tar -zcf ./mce-$VER.tar.gz ./mce-$VER

# display some info to stdout to verify dir structure and spec file replacements
echo "rpmbuild directory looks like this"
echo "------------------------------------------------------------------"
tree /root/rpmbuild
echo "------------------------------------------------------------------"

echo "MCE spec file looks like this:"
echo "------------------------------------------------------------------"
cat /root/rpmbuild/SPECS/mce.spec
echo "------------------------------------------------------------------"

echo "Now building RPM:"
echo "------------------------------------------------------------------"
pushd /root/rpmbuild/SPECS
rpmbuild -v -bb mce.spec
echo "------------------------------------------------------------------"


echo "Now uploading RPM to Artifactory:"
echo "------------------------------------------------------------------"
pushd /root/rpmbuild/RPMS/noarch
curl -v -X PUT "https://artifacts.company.com/artifactory/cdl-yum-internal/mce-$VER-$BUILDNUM.el7.centos.noarch.rpm" --data-binary @mce-$VER-$BUILDNUM.el7.centos.noarch.rpm
echo "------------------------------------------------------------------"


#!/bin/bash

buildNumber=$1
buildBranch=$2
pushd cl-merchant_cleaning
./git.sh -i /root/.ssh/id_rsa pull
pushd ./cl-merchant_cleaning
git checkout $buildBranch
./git.sh -i /root/.ssh/id_rsa pull
pushd ./mce
echo "Current working directory is " $(pwd)
sbt "set version:=version.value+'.'+$buildNumber" assembly publish
pushd ../parser
echo "Current working directory is " $(pwd)
sbt "set version:=version.value+'.'+$buildNumber" assembly publish



#!/bin/bash

BUILD_SERVER="BUILD_SERVER URL"
SERVICE=@option.service@
BRANCH=@option.branch@
BUILD_VERSION=@option.build_version@

REPO_NAME=@option.repo_name@

IS_MS=@option.IS_MS@

cd /var/lib/rundeck/scripts/micro-service-images

echo "create directoty $BUILD_VERSION"

mkdir $BUILD_VERSION


cd  $BUILD_VERSION

pwd

BUILD_URL=''
if [ "$IS_MS" = true ] ; then
    BUILD_URL=$BUILD_SERVER/microservices-builds/$SERVICE/$BRANCH/$BUILD_VERSION.tar.gz
 else
     BUILD_URL=$BUILD_SERVER/$SERVICE/$BRANCH/$BUILD_VERSION.tar.gz
fi

echo $BUILD_URL


curl  "$BUILD_URL" | tar -xz 

if [ "$?" -ne 0 ]
then 	
    echo "Failed the download the build"
    #cd ..
    #rm -rf $BUILD_VERSION
    exit 1
fi


version=`jq '.version' package.json |  tr -d '"'`

echo  "building the image"
  
echo $REPO_NAME
docker build -t $REPO_NAME .
if [ $? -ne 0 ]
then 	
    echo "failed to build docker iamge"
    cd ..
    rm -rf $BUILD_VERSION
    exit 1
fi
echo "deleting the folder"
cd ..
rm -rf $BUILD_VERSION
docker tag $REPO_NAME:latest $REPO_URN/$REPO_NAME:v$version


$(aws ecr get-login --region ap-southeast-1  --profile profile_name | sed -e 's/-e none//g' )

docker push $REPO_URN/$REPO_NAME:v$version

docker rmi -f $REPO_URN/$REPO_NAME:v$version
docker rmi -f $REPO_NAME:latest


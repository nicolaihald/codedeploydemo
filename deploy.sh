#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "No version supplied"
	exit
fi

version=$1
echo "Pushing version ${version} to S3..."; 
aws deploy push --application-name DemoApp --description 'This is revision ${version}' --ignore-hidden-files --s3-location s3://codedeploy-demoapp/DemoApp_v${version}.zip --source .

echo "Creating new deployment for version ${version}" 
aws deploy create-deployment --application-name DemoApp --deployment-group-name DemoApp_DG --deployment-config-name CodeDeployDefault.OneAtATime --s3-location bucket=codedeploy-demoapp,key=DemoApp_v${version}.zip,bundleType=zip


exit $?

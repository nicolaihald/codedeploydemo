#!/bin/bash

#Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}`


#Initialize variables to default values.
OPT_TYPE='simple'
OPT_VERSION='0'

#Help function
function HELP {
  echo -e \\n"Help documentation for ${SCRIPT}"
  echo -e "Basic usage: $SCRIPT -v [version] -t [deployment_type] }"\\n
  # echo "Command line switches are optional. The following switches are recognized."
  # echo "${REV}-a${NORM}  --Sets the value for option ${BOLD}a${NORM}. Default is ${BOLD}A${NORM}."
  # echo "${REV}-b${NORM}  --Sets the value for option ${BOLD}b${NORM}. Default is ${BOLD}B${NORM}."
  # echo "${REV}-c${NORM}  --Sets the value for option ${BOLD}c${NORM}. Default is ${BOLD}C${NORM}."
  # echo "${REV}-d${NORM}  --Sets the value for option ${BOLD}d${NORM}. Default is ${BOLD}D${NORM}."
  # echo -e "${REV}-h${NORM}  --Displays this help message. No further functions are performed."\\n
  echo -e "Example: $SCRIPT -v 1.0 -t [update|new]"\\n
  exit 1
}


### Start getopts code ###

#Parse command line flags
#If an option should be followed by an argument, it should be followed by a ":".
#Notice there is no ":" after "h". The leading ":" suppresses error messages from
#getopts. This is required to get my unrecognized option code to work.

while getopts "v:t:h" opt; do
  case $opt in
	t)
	  OPT_TYPE=$OPTARG
	  # echo "-t used: $OPTARG"
      echo "OPT_TYPE = $OPT_TYPE"
      ;;
    v)
	  OPT_VERSION=$OPTARG
	  # echo "-v used: $OPTARG"
      echo "OPT_VERSION = $OPT_VERSION"
      ;;
    h)  #show help
      HELP
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      HELP
      #If you just want to display a simple error message instead of the full
      #help, remove the 2 lines above and uncomment the 2 lines below.
      #echo -e "Use ${BOLD}$SCRIPT -h${NORM} to see the help documentation."\\n
      #exit 2
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.

### End getopts code ###
if [ $OPT_VERSION == '0' ]
  then
    echo "No version supplied. Pass version number using the '-t' parameter (fx. '-t 1.0')."
	exit
fi






echo "Pushing version ${OPT_VERSION} to S3..."; 
aws deploy push --application-name DemoApp --description 'This is revision ${OPT_VERSION}' --ignore-hidden-files --s3-location s3://codedeploy-demoapp/DemoApp_v${OPT_VERSION}.zip --source .

echo "Creating new deployment for version ${OPT_VERSION}" 
aws deploy create-deployment --application-name DemoApp --deployment-group-name DemoApp_DG --deployment-config-name CodeDeployDefault.OneAtATime --s3-location bucket=codedeploy-demoapp,key=DemoApp_v${OPT_VERSION}.zip,bundleType=zip



# http://52.31.107.180/b25e917b-9398-44c1-abe3-fa847d7b34ef/#/info/lang-beskrivelse-med-videoer


exit $?

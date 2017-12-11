#!/bin/sh

cd "${PROJECT_DIR}"

dir=${PROJECT_DIR}/config
echo "Starting environment ${ENVIRONMENT} configuration for ${PROJECT_NAME}/${PROJECT_FOLDER} with config in " $dir
echo "Host: " `hostname`

# environment variable from value passed in to xcodebuild.
# if not specified, we default to DEV
envMode=${ENVIRONMENT}

infoEnv="Info-$envMode"
FILE=${PROJECT_DIR}/config/Environment/$infoEnv.plist

if [ -z "$infoEnv" ] || [ ! -f $FILE ]
then
echo "NO FILE $infoEnv"
env="Info-default"
fi

googleEnv="GoogleService-Info-$envMode"

FILE=${PROJECT_DIR}/config/Environment/$googleEnv.plist

if [ -z "$googleEnv" ] || [ ! -f $FILE ]
then
echo "NO GOOGLE FILE $googleEnv"
googleEnv="GoogleService-Info-default"
fi

echo "Using $env environment"
echo "Using $googleEnv google settings"

# copy the environment-specific file
cp $dir/Default/$env.plist $dir/Using/Info-environment.plist

# copy the google environment-specific file
cp $dir/Default/$googleEnv.plist $dir/Using/Google-environment.plist

# Date and time that we are running this build
buildDate=`date "+%F %H:%M:%S"`

# app settings from Info.plist
bundleName=`/usr/libexec/PlistBuddy -c "Print :CFBundleName" "$dir/Using/Info-environment.plist"`
bundleIdentifier=`/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$dir/Using/Info-environment.plist"`
bundleVerions=`/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$dir/Using/Info-environment.plist"`
bundleVerionsShortString=`/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$dir/Using/Info-environment.plist"`
infoDictionaryVersion=`/usr/libexec/PlistBuddy -c "Print :CFBundleInfoDictionaryVersion" "$dir/Using/Info-environment.plist"`
fabricAPIKey=`/usr/libexec/PlistBuddy -c "Print :FABRIC_API_KEY" "$dir/Using/Info-environment.plist"`
fabricBuildSecret=`/usr/libexec/PlistBuddy -c "Print :FABRIC_BUILD_SECRET" "$dir/Using/Info-environment.plist"`
serverUrl=`/usr/libexec/PlistBuddy -c "Print :Server_URL" "$dir/Using/Info-environment.plist"`
isMainNetSetting=`/usr/libexec/PlistBuddy -c "Print :Is_Mainnet_setting" "$dir/Using/Info-environment.plist"`

# Build the preprocess file
cd "${PROJECT_DIR}"
preprocessFile="environment_preprocess.h"

echo "Creating header file ${PROJECT_DIR}/${preprocessFile}"

echo "//------------------------------------------" > $preprocessFile
echo "// Auto generated file. Don't edit manually." >> $preprocessFile
echo "// See build_environment script for details." >> $preprocessFile
echo "// Created $buildDate" >> $preprocessFile
echo "//------------------------------------------" >> $preprocessFile
echo "" >> $preprocessFile
echo "#define ENV                $env" >> $preprocessFile

echo "#define ENV_BUNDLE_NAME                                   $bundleName" >> $preprocessFile
echo "#define ENV_BUNDLE_IDENTIFIER                             $bundleIdentifier" >> $preprocessFile
echo "#define ENV_BUNDLE_VERSION                                $bundleVerions" >> $preprocessFile
echo "#define ENV_BUNDLE_VERSION_SHORT_STRING                   $bundleVerionsShortString" >> $preprocessFile
echo "#define ENV_INFO_DICTIONARY_VERSION                       $infoDictionaryVersion" >> $preprocessFile
echo "#define ENV_FABRIC_API_KEY                                $fabricAPIKey" >> $preprocessFile
echo "#define ENV_FABRIC_BUILD_SECRET                           $fabricBuildSecret" >> $preprocessFile
echo "#define ENV_SERVER_URL                                    $serverUrl" >> $preprocessFile
echo "#define ENV_IS_MAINNET_SETTING                            $isMainNetSetting" >> $preprocessFile

# dump out file to build log
cat $preprocessFile

# Force the system to process the plist file
echo "Touching all plists at: ${PROJECT_DIR}/**/Info.plist"

touch ${PROJECT_DIR}/qtum\ wallet/Info.plist

# done
echo "Done."

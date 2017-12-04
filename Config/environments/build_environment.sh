#!/bin/sh

#  build_environment.sh
#
#  Created by Andrew C on 7/27/15.
#  Released under MIT LICENSE
#  Copyright (c) 2015 Andrew Crookston.


cd "${PROJECT_DIR}"

dir=${PROJECT_DIR}/config/environments
echo "Starting environment ${ENVIRONMENT} configuration for ${PROJECT_NAME}/${PROJECT_FOLDER} with config in " $dir
echo "Host: " `hostname`

# environment variable from value passed in to xcodebuild.
# if not specified, we default to DEV
envMode=${ENVIRONMENT}

infoEnv="Info-$envMode"
FILE=${PROJECT_DIR}/config/environments/Environment/$infoEnv.plist

if [ -z "$infoEnv" ] || [ ! -f $FILE ]
then
echo "NO FILE $infoEnv"
env="Info-default"
fi

googleEnv="GoogleService-Info-$envMode"

FILE=${PROJECT_DIR}/config/environments/Environment/$googleEnv.plist

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

# app settings from GoogleService.plist
googleAdUnitIdForBannerTest=`/usr/libexec/PlistBuddy -c "Print :AD_UNIT_ID_FOR_BANNER_TEST" "$dir/Using/Google-environment.plist"`
googleAdUnitIdForInterstitialTest=`/usr/libexec/PlistBuddy -c "Print :AD_UNIT_ID_FOR_INTERSTITIAL_TEST" "$dir/Using/Google-environment.plist"`
googleClientId=`/usr/libexec/PlistBuddy -c "Print :CLIENT_ID" "$dir/Using/Google-environment.plist"`
googleReversedClientId=`/usr/libexec/PlistBuddy -c "Print :REVERSED_CLIENT_ID" "$dir/Using/Google-environment.plist"`
googleApiKey=`/usr/libexec/PlistBuddy -c "Print :API_KEY" "$dir/Using/Google-environment.plist"`
googleGcmSenderId=`/usr/libexec/PlistBuddy -c "Print :GCM_SENDER_ID" "$dir/Using/Google-environment.plist"`
googlePlistVersion=`/usr/libexec/PlistBuddy -c "Print :PLIST_VERSION" "$dir/Using/Google-environment.plist"`
googleBundleId=`/usr/libexec/PlistBuddy -c "Print :BUNDLE_ID" "$dir/Using/Google-environment.plist"`
googleProjectId=`/usr/libexec/PlistBuddy -c "Print :PROJECT_ID" "$dir/Using/Google-environment.plist"`
googleStorageBucket=`/usr/libexec/PlistBuddy -c "Print :STORAGE_BUCKET" "$dir/Using/Google-environment.plist"`
googleAppId=`/usr/libexec/PlistBuddy -c "Print :GOOGLE_APP_ID" "$dir/Using/Google-environment.plist"`
googleDatabaseUrl=`/usr/libexec/PlistBuddy -c "Print :DATABASE_URL" "$dir/Using/Google-environment.plist"`
googleIsAdsEnabled=`/usr/libexec/PlistBuddy -c "Print :IS_ADS_ENABLED" "$dir/Using/Google-environment.plist"`
googleIsAnalyticsEnabled=`/usr/libexec/PlistBuddy -c "Print :IS_ANALYTICS_ENABLED" "$dir/Using/Google-environment.plist"`
googleIsAppinviteEnabled=`/usr/libexec/PlistBuddy -c "Print :IS_APPINVITE_ENABLED" "$dir/Using/Google-environment.plist"`
googleIsGcmEnabled=`/usr/libexec/PlistBuddy -c "Print :IS_GCM_ENABLED" "$dir/Using/Google-environment.plist"`
googleIsSigninEnabled=`/usr/libexec/PlistBuddy -c "Print :IS_SIGNIN_ENABLED" "$dir/Using/Google-environment.plist"`

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
echo "#define ENV_GOOGLE_AD_UNIT_ID_FOR_BANNER_TEST             $googleAdUnitIdForBannerTest" >> $preprocessFile
echo "#define ENV_GOOGLE_AD_UNIT_ID_FOR_INTERSTITIAL_TEST       $googleAdUnitIdForInterstitialTest" >> $preprocessFile
echo "#define ENV_GOOGLE_CLIENT_ID                              $googleClientId" >> $preprocessFile
echo "#define ENV_GOOGLE_REVERSED_CLIENT_ID                     $googleReversedClientId" >> $preprocessFile
echo "#define ENV_GOOGLE_API_KEY                                $googleApiKey" >> $preprocessFile
echo "#define ENV_GOOGLE_GCM_SENDER_ID                          $googleGcmSenderId" >> $preprocessFile
echo "#define ENV_GOOGLE_PLIST_VERSION                          $googlePlistVersion" >> $preprocessFile
echo "#define ENV_GOOGLE_BUNDLE_ID                              $googleBundleId" >> $preprocessFile
echo "#define ENV_GOOGLE_STORAGE_BUCKET                         $googleStorageBucket" >> $preprocessFile
echo "#define ENV_GOOGLE_PROJECT_ID                             $googleProjectId" >> $preprocessFile
echo "#define ENV_GOOGLE_APP_ID                                 $googleAppId" >> $preprocessFile
echo "#define ENV_GOOGLE_DATABASE_URL                           $googleDatabaseUrl" >> $preprocessFile
echo "#define ENV_GOOGLE_IS_ADS_ENABLED                         $googleIsAdsEnabled" >> $preprocessFile
echo "#define ENV_GOOGLE_IS_ANALYTICS_ENABLED                   $googleIsAnalyticsEnabled" >> $preprocessFile
echo "#define ENV_GOOGLE_IS_APPINVITE_ENABLED                   $googleIsAppinviteEnabled" >> $preprocessFile
echo "#define ENV_GOOGLE_IS_SIGNIN_ENABLED                      $googleIsSigninEnabled" >> $preprocessFile

# dump out file to build log
cat $preprocessFile

# Force the system to process the plist file
echo "Touching all plists at: ${PROJECT_DIR}/**/Info.plist"
touch ${PROJECT_DIR}/**/Info.plist

# done
echo "Done."

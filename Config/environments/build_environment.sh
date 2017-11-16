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
env=${ENVIRONMENT}
FILE=${PROJECT_DIR}/config/environments/$env.plist

if [ -z "$env" ] || [ ! -f $FILE ]
then
echo "NO FILE $env"
env="default"
fi

echo "Using $env environment"

# copy the environment-specific file
cp $dir/$env.plist $dir/environment.plist

# Date and time that we are running this build
buildDate=`date "+%F %H:%M:%S"`

# app settings
bundleName=`/usr/libexec/PlistBuddy -c "Print :CFBundleName" "$dir/environment.plist"`
bundleIdentifier=`/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$dir/environment.plist"`
bundleVerions=`/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$dir/environment.plist"`
bundleVerionsShortString=`/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$dir/environment.plist"`
infoDictionaryVersion=`/usr/libexec/PlistBuddy -c "Print :CFBundleInfoDictionaryVersion" "$dir/environment.plist"`
fabricAPIKey=`/usr/libexec/PlistBuddy -c "Print :FABRIC_API_KEY" "$dir/environment.plist"`
fabricBuildSecret=`/usr/libexec/PlistBuddy -c "Print :FABRIC_BUILD_SECRET" "$dir/environment.plist"`
serverUrl=`/usr/libexec/PlistBuddy -c "Print :Server_URL" "$dir/environment.plist"`
isMainNetSetting=`/usr/libexec/PlistBuddy -c "Print :Is_Mainnet_setting" "$dir/environment.plist"`
googleAdUnitIdForBannerTest=`/usr/libexec/PlistBuddy -c "Print :AD_UNIT_ID_FOR_BANNER_TEST" "$dir/environment.plist"`
googleAdUnitIdForInterstitialTest=`/usr/libexec/PlistBuddy -c "Print :AD_UNIT_ID_FOR_INTERSTITIAL_TEST" "$dir/environment.plist"`
googleClientId=`/usr/libexec/PlistBuddy -c "Print :CLIENT_ID" "$dir/environment.plist"`
googleReversedClientId=`/usr/libexec/PlistBuddy -c "Print :REVERSED_CLIENT_ID" "$dir/environment.plist"`
googleApiKey=`/usr/libexec/PlistBuddy -c "Print :API_KEY" "$dir/environment.plist"`
googleGcmSenderId=`/usr/libexec/PlistBuddy -c "Print :GCM_SENDER_ID" "$dir/environment.plist"`
googlePlistVersion=`/usr/libexec/PlistBuddy -c "Print :PLIST_VERSION" "$dir/environment.plist"`
googleBundleId=`/usr/libexec/PlistBuddy -c "Print :BUNDLE_ID" "$dir/environment.plist"`
googleProjectId=`/usr/libexec/PlistBuddy -c "Print :PROJECT_ID" "$dir/environment.plist"`
googleStorageBucket=`/usr/libexec/PlistBuddy -c "Print :STORAGE_BUCKET" "$dir/environment.plist"`
googleAppId=`/usr/libexec/PlistBuddy -c "Print :GOOGLE_APP_ID" "$dir/environment.plist"`
googleDatabaseUrl=`/usr/libexec/PlistBuddy -c "Print :DATABASE_URL" "$dir/environment.plist"`
googleIsAdsEnabled=`/usr/libexec/PlistBuddy -c "Print :IS_ADS_ENABLED" "$dir/environment.plist"`
googleIsAnalyticsEnabled=`/usr/libexec/PlistBuddy -c "Print :IS_ANALYTICS_ENABLED" "$dir/environment.plist"`
googleIsAppinviteEnabled=`/usr/libexec/PlistBuddy -c "Print :IS_APPINVITE_ENABLED" "$dir/environment.plist"`
googleIsGcmEnabled=`/usr/libexec/PlistBuddy -c "Print :IS_GCM_ENABLED" "$dir/environment.plist"`
googleIsSigninEnabled=`/usr/libexec/PlistBuddy -c "Print :IS_SIGNIN_ENABLED" "$dir/environment.plist"`

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

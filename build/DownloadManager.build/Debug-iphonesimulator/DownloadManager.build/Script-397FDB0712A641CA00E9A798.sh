#!/bin/sh
# Purpose:
#   Create a static library for iPhone from within XCode
#   Because Apple staff DELIBERATELY broke Xcode to make this impossible from the GUI (Xcode 3.2.3 specifically states this in the Release notes!)
#   ...no, I don't understand why they did such a stupid thing either!
#
# Author: Adam Martin - http://twitter.com/redglassesapps
# Based on: original script from Eonil (main changes: Eonil's script WILL NOT WORK in Xcode GUI - it WILL CRASH YOUR COMPUTER)
#
# More info: see this Stack Overflow question: http://stackoverflow.com/questions/3520977/build-fat-static-library-device-simulator-using-xcode-and-sdk-4


#####################[ part 1 ]##################
# First, work out the BASESDK version number (NB: Apple ought to report this, but they hide it)
#    (incidental: searching for substrings in sh is a nightmare! Sob)

SDK_VERSION=$(echo ${SDK_NAME} | grep -o '.\{3\}$')

# Next, work out if we're in SIM or DEVICE

if [ ${PLATFORM_NAME} = "iphonesimulator" ]
then
OTHER_SDK_TO_BUILD=iphoneos${SDK_VERSION}
else
OTHER_SDK_TO_BUILD=iphonesimulator${SDK_VERSION}
fi

echo "XCode has selected SDK: ${PLATFORM_NAME} with version: ${SDK_VERSION} (although back-targetting: ${IPHONEOS_DEPLOYMENT_TARGET})"
echo "...therefore, OTHER_SDK_TO_BUILD = ${OTHER_SDK_TO_BUILD}"
#
#####################[ end of part 1 ]##################

#####################[ part 2 ]##################
#
# IF this is the original invocation, invoke WHATEVER other builds are required
#
# Xcode is already building ONE target...
#
# ...but this is a LIBRARY, so Apple is wrong to set it to build just one.
# ...we need to build ALL targets
# ...we MUST NOT re-build the target that is ALREADY being built: Xcode WILL CRASH YOUR COMPUTER if you try this (infinite recursion!)
#
#
# So: build ONLY the missing platforms/configurations.

if [ "true" = ${ALREADYINVOKED} ]
then
echo "RECURSION: I am NOT the root invocation, so I'm NOT going to recurse"
else
# CRITICAL:
# Prevent infinite recursion (Xcode sucks)
export ALREADYINVOKED="true"

echo "RECURSION: I am the root ... recursing all missing build targets NOW..."
echo "RECURSION: ...about to invoke: xcodebuild -configuration \"${CONFIGURATION}\" -target \"${TARGET_NAME}\" -sdk \"${OTHER_SDK_TO_BUULD}\" ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO"
xcodebuild -configuration "${CONFIGURATION}" -target "${TARGET_NAME}" -sdk "${OTHER_SDK_TO_BUILD}" ${ACTION} RUN_CLANG_STATIC_ANALYZER=NO
fi

ACTION="build"

#Merge all platform binaries as a fat binary for each configurations.

CURRENTCONFIG_DEVICE_DIR=${SYMROOT}/${CONFIGURATION}-iphoneos
CURRENTCONFIG_SIMULATOR_DIR=${SYMROOT}/${CONFIGURATION}-iphonesimulator
CURRENTCONFIG_UNIVERSAL_DIR=${SYMROOT}/${CONFIGURATION}-universal

# ... remove the products of previous runs of this script
#      NB: this directory is ONLY created by this script - it should be safe to delete!

rm -rf "${CURRENTCONFIG_UNIVERSAL_DIR}"
mkdir "${CURRENTCONFIG_UNIVERSAL_DIR}"

#
echo "lipo: for current configuration (${CONFIGURATION}) creating output file: ${CURRENTCONFIG_UNIVERSAL_DIR}/${EXECUTABLE_NAME}"
lipo -create -output "${CURRENTCONFIG_UNIVERSAL_DIR}/${EXECUTABLE_NAME}" "${CURRENTCONFIG_DEVICE_DIR}/${EXECUTABLE_NAME}" "${CURRENTCONFIG_SIMULATOR_DIR}/${EXECUTABLE_NAME}"

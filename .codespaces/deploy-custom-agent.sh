#!/bin/bash

#ERROR_STR=" See /tmp/deploy-custom-agent.log for info"

set -e

function check_err {
    if [ $? -ne 0 ]; then
    echo "⚠ Could not $1. Please try this step manually."
    exit 1
    fi
}

if [[ $1 != "--no-build" ]]; then
    pushd $CASCADE_ROOT
    echo "🚀 Building your AGENT changes..."
    dotnet clean $CASCADE_ROOT/src/VSOnline > /tmp/cascade-build-log.txt
    dotnet build $CASCADE_ROOT/src/VSOnline >> /tmp/cascade-build-log.txt
    check_err "build agent (log: /tmp/cascade-build-log.txt)"

    pushd $VSCLK_ROOT
    echo "🚀 Building your VSCLK-CORE changes..."
    dotnet build $VSCLK_ROOT  > /tmp/vsclk-build-log.txt
    check_err "build vsclk-core (log: /tmp/vsclk-build-log.txt)"
fi

echo "🚀 Generating artifacts..."
dotnet $CASCADE_ROOT/bin/Debug/VSOnline.DevTool/DevTool.dll generateArtifacts $CASCADE_ROOT | tee /tmp/gen_artifacts.txt
check_err "generate artifacts with DevTool.dll"

ARTIFACTS_PATH=`cat /tmp/gen_artifacts.txt | awk '/Artifact located at: /{print $NF}'`
ARTIFACTS_ID=`echo $ARTIFACTS_PATH |grep -o '[0-9]\+'`

echo "🚀 Uploading artifacts..."
pushd $VSCLK_ROOT/bin/debug/VsoUtil
UseSecretFromAppConfig=1
dotnet $VSCLK_ROOT/bin/debug/VsoUtil/VsoUtil.dll preparedevcli -c $ARTIFACTS_PATH -v $ARTIFACTS_ID --secret-from-app-config
check_err "upload artifacts with VsoUtil.dll"

echo "🎉 Artifacts with ID=$ARTIFACTS_ID have been uploaded."

echo "🚀 Disabling \"autoUploadLocalVMAgents\" in appsettings.json..."
sed -i "s|\"autoUploadLocalVMAgents\": true|\"autoUploadLocalVMAgents\": false|" ~/CEDev/appsettings.json
echo "🎉 Disabled \"autoUploadLocalVMAgents\" in appsettings.json."

set +e

#!/bin/bash

pushd $VSCLK_ROOT/bin/debug/VsoUtil/
UseSecretFromAppConfig=1 dotnet VsoUtil.dll cleandevstamp

#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo -e $PALETTE_RED"\n Do not run ./setup-vsclk.sh directly. Run script from ./init_repos.sh \n"$PALETTE_RESET
    exit 1
fi

echo -e $PALETTE_LIGHT_YELLOW"\n ⌬ Fetching the VSCLK repo\n"$PALETTE_RESET
mkdir vsclk-core
pushd ./vsclk-core
export VSCLK_ROOT=`pwd`
echo -e "export VSCLK_ROOT=$VSCLK_ROOT" >> ~/.cs-environment


EMPTY_STRING=""
CLEAN_ORIGIN="${VSCLK_REPO_URL/https\:\/\//$EMPTY_STRING}"


# clone the vsclk repo
git clone https://PAT:$ADO_PAT@$CLEAN_ORIGIN .


if [[ -z "$VSCLK_ROOT" ]]; then
  echo -e $PALETTE_RED"\n ERROR: VSCLK_ROOT env variable not set.\n"$PALETTE_RESET
  exit -1
fi

## NUGET SETUP IS DONE FROM THE setup-cascade.sh script as this Nuget.config is a subset of the cascade one.

if [[ -z "$ADO_PAT_BASE64" ]]; then
  echo -e $PALETTE_RED"\n ERROR: ADO_PAT_BASE64 env variable not set.\n"$PALETTE_RESET
  exit -1
fi

# get the .npmrc file path
unset NPMRC_FILE_PATH
# 1. check the NPMRC_CONFIG_FILE_PATH variable set by the uer first
if ! [ -z $NPMRC_CONFIG_FILE_PATH ] 2> /dev/null && [ -f $NPMRC_CONFIG_FILE_PATH ];
then
    NPMRC_FILE_PATH=$NPMRC_CONFIG_FILE_PATH
# 2. check the repo root next
elif [ -f $VSCLK_ROOT/.npmrc ]
then
    NPMRC_FILE_PATH=$VSCLK_ROOT/.npmrc
fi

if ! [ -z $NPMRC_FILE_PATH ] 2> /dev/null && [ -f $NPMRC_FILE_PATH ]; then
  echo -e "Generating npmrc config file.. "
  FEEDS=$(cat $NPMRC_FILE_PATH | sed -n 's/.*registry=https:\([^\n]*\).*/\1/p')
  feeds_array=($FEEDS)

  i=0
  FEEDS_STRING=""
  for FEED_URL in "${feeds_array[@]}"
  do
    CLEAN_FEED_URL=${FEED_URL%"registry/"}
    FEEDS_STRING="$FEEDS_STRING
; begin auth token\n
$FEED_URL:username=uname\n
$FEED_URL:_password=$ADO_PAT_BASE64\n
$FEED_URL:email=npm requires email to be set but doesn't use the value\n
$CLEAN_FEED_URL:username=uname\n
$CLEAN_FEED_URL:_password=$ADO_PAT_BASE64\n
$CLEAN_FEED_URL:email=npm requires email to be set but doesn't use the value\n
; end auth token\n
\n\n"
    i=$((i+1))
  done
fi

echo -e $FEEDS_STRING >> ~/.npmrc

echo -e $PALETTE_BLUE"\n ⌬ Restoring VSCLK Packages\n"$PALETTE_RESET
dotnet restore

popd

echo -e $PALETTE_GREEN"\n ⌬ VSCLK Setup Complete.\n"$PALETTE_RESET

# exec bash
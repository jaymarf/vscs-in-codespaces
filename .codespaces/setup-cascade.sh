#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo -e $PALETTE_RED"\n Do not run ./setup-cascade.sh  directly. Run script from ./init_repos.sh \n"$PALETTE_RESET
    exit 1
fi

echo -e $PALETTE_LIGHT_YELLOW"\n ⌬ Fetching the CASCADE repo\n"$PALETTE_RESET
mkdir cascade
pushd ./cascade
export CASCADE_ROOT=`pwd`
echo -e "export CASCADE_ROOT=$CASCADE_ROOT" >> ~/.cs-environment


EMPTY_STRING=""
CLEAN_ORIGIN="${CASCADE_REPO_URL/https\:\/\//$EMPTY_STRING}"

# clone the cascade repo
git clone https://PAT:$ADO_PAT@$CLEAN_ORIGIN .

#### NUGET

echo -e $PALETTE_BLUE"\n ⌬ Setting up nuget config\n"$PALETTE_RESET
mkdir -p ~/.nuget/NuGet/

# get the NuGet.Config file path
unset NUGET_FILE_PATH
# 1. check the NUGET_CONFIG_FILE_PATH variable set by the user first
if ! [ -z $NUGET_CONFIG_FILE_PATH ] 2> /dev/null && [ -f $NUGET_CONFIG_FILE_PATH ];
then
    NUGET_FILE_PATH=$NUGET_CONFIG_FILE_PATH
# 2. check the repo root next
elif [ -f $CASCADE_ROOT/NuGet.config ]
then
    NUGET_FILE_PATH=$CASCADE_ROOT/NuGet.config
# 3. check the user folder finally
elif [ -f ~/.nuget/NuGet/NuGet.Config ]
then
  NUGET_FILE_PATH=~/.nuget/NuGet/NuGet.Config
fi

if ! [ -z $NUGET_FILE_PATH ] 2> /dev/null && [ -f $NUGET_FILE_PATH ]; then
  NAMES=$(cat $NUGET_FILE_PATH | sed -n 's/<add.*key="\([^"]*\).*/\1/p')
  names_array=($NAMES)

  URLS=$(cat $NUGET_FILE_PATH | sed -n '/<add.*key="\(.*\)"/s/.*value="\(.*\)"[^\n]*/\1/p')
  urls_array=($URLS)

  FEEDS=""
  i=0
  for FEED_NAME in "${names_array[@]}"
  do
      FEED_URL=(${urls_array[$i]})
      FEEDS="$FEEDS\n\t\t<add key=\"$FEED_NAME\" value=\"$FEED_URL\" />"
      i=$((i+1))
  done

  CREDENTIALS=""
  for FEED_NAME in "${names_array[@]}"
  do
      CREDENTIAL="<$FEED_NAME>
      <add key=\"Username\" value=\"devdiv\" />
      <add key=\"ClearTextPassword\" value=\"%ADO_PAT%\" />
  </$FEED_NAME>"

      CREDENTIALS="$CREDENTIALS\n$CREDENTIAL"
  done

  echo -e "<?xml version=\"1.0\" encoding=\"utf-8\"?>
  <configuration>
  \t<packageSources>$FEEDS
  \t</packageSources>
  \t<packageSourceCredentials>$CREDENTIALS
  \t</packageSourceCredentials>
  </configuration>
  " > ~/.nuget/NuGet/NuGet.Config
fi
### END NUGET SETUP

echo -e $PALETTE_BLUE"\n ⌬ Restoring CASCADE Packages\n"$PALETTE_RESET
dotnet restore

popd

echo -e $PALETTE_GREEN"\n ⌬ CASCADE Setup Complete.\n"$PALETTE_RESET

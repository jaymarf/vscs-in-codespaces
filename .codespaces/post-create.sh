echo "post-create running.."

# add libssl
echo "deb http://security.debian.org/debian-security jessie/updates main" | sudo tee -a /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9D6D8F6BC857C906
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends libssl1.0.0

# add dotnet sdk v3.1.404
# curl -SL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/3.1.404/dotnet-sdk-3.1.404-linux-x64.tar.gz --output dotnet.tar.gz
# tar -zxf dotnet.tar.gz -C /home/codespace/.dotnet --skip-old-files
# rm dotnet.tar.gz

# add oh-my-bash
wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O - | sh -C

BASH_RC_FILE=~/.bashrc

PRE_OMB_BASH_CONFIG=~/.bashrc.pre-oh-my-bash
if [ -f $PRE_OMB_BASH_CONFIG ]; then
  cat $PRE_OMB_BASH_CONFIG >> $BASH_RC_FILE
  rm $PRE_OMB_BASH_CONFIG
fi

# add .bashrc config
echo "
## Color variables

# Dimmed text
export PALETTE_DIM='\e[2m'

# Bold Text
export PALETTE_BOLD='\e[1m'

# Underlined Text
export PALETTE_UNDERLINED='\e[4m'

# Blinking
export PALETTE_BLINK='\e[5m'

# Reverse
export PALETTE_REVERSE='\e[7m'

# Foreground Color
export PALETTE_BLACK='\e[30m'
export PALETTE_WHITE='\e[97m'
export PALETTE_RED='\e[31m'
export PALETTE_GREEN='\e[32m'
export PALETTE_BROWN='\e[33m'
export PALETTE_BLUE='\e[34m'
export PALETTE_PURPLE='\e[35m'
export PALETTE_CYAN='\e[36m'
export PALETTE_LIGHTGRAY='\e[37m'
export PALETTE_LIGHT_YELLOW='\e[93m'

# Background Color
export PALETTE_BLACK_U='\e[40m'
export PALETTE_RED_U='\e[41m'
export PALETTE_GREEN_U='\e[42m'
export PALETTE_BROWN_U='\e[43m'
export PALETTE_BLUE_U='\e[44m'
export PALETTE_PURPLE_U='\e[45m'
export PALETTE_CYAN_U='\e[46m'
export PALETTE_LIGHTGRAY_U='\e[47m'

# Normal Text
export PALETTE_RESET='\e[0m'

# workspace
export CODESPACE_ROOT=$(pwd)
alias cdroot='cd \$CODESPACE_ROOT'
alias ya='yarn'
# misc
code()
{
  if code-insiders -v &> /dev/null; then
      code-insiders \$@;
    else
      code \$@;
  fi
}
export -f code
alias ls='ls --color=auto'
alias ww='watch -n 1 \"date && echo -e \ &&\"'
alias refresh='exec bash'
alias bashconfig=\"code $BASH_RC_FILE\"
alias nugetconfig=\"code ~/.nuget/NuGet/NuGet.Config\"
alias ports='lsof -n -i -P | grep TCP'

if [ -f ~/.cs-environment ]; then
    source ~/.cs-environment
fi

export PATH=$PATH:~/workspace/vscs-in-codespaces/.codespaces

" >> $BASH_RC_FILE

# Git Defaults
git config --global pull.rebase false

# Copy appsettings.json and testsettings.json templates to ~/CEDev where it's expected to be.
# Pre-populate it with environment variables if they've been supplied.
mkdir ~/CEDev
cp ~/ado-in-codespaces/.codespaces/CEDev/* ~/CEDev
GITHUB_USERNAME=`git config user.name`

if [ -n "$DEVELOPER_ALIAS" ]; then
  sed -i "s/\"developerAlias\": \"\"/\"developerAlias\": \"$DEVELOPER_ALIAS\"/" ~/CEDev/appsettings.json
fi

if [ -n "$TUNNEL_KEY" ]; then
  sed -i "s/\"tunnelRelayPrimaryAuthKey\": \"\"/\"tunnelRelayPrimaryAuthKey\": \"$TUNNEL_KEY\"/" ~/CEDev/appsettings.json
fi

if [ -n "$APP_SECRET" ]; then
  sed -i "s|\"appServicePrincipalClientSecret\": \"\"|\"appServicePrincipalClientSecret\": \"$APP_SECRET\"|" ~/CEDev/appsettings.json
fi

sed -i "s/\"userId\": \"\"/\"userId\": \"$GITHUB_USERNAME\"/" ~/CEDev/testsettings.json

if [ -n "$CODESPACES_TOKEN" ]; then
  sed -i "s/\"token\": \"\"/\"token\": \"$CODESPACES_TOKEN\"/" ~/CEDev/testsettings.json
fi

# Show hint of how to proceed on first launch
if [ ! -f ~/.cs-environment ]; then
  clear
  echo -e "💡 Open$PALETTE_BOLD agent-development.code-workspace$PALETTE_RESET and select$PALETTE_BOLD OPEN WORKSPACE$PALETTE_RESET once all repos are cloned.$PALETTE_RESET \n$PALETTE_RESET"
fi

# Run the init script if ADO_PAT is already defined via GH secrets
if [ -n "$ADO_PAT" ]; then
  source .codespaces/init_repos.sh
fi

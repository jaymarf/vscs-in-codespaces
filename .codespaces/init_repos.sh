#!/bin/bash

# clear
echo "init-repos running.."

# cp -Ru . ~/ado-in-codespaces
export CACHE_FILE_PATH=~/.ado-in-codespaces-cache

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -f $CACHE_FILE_PATH ]; then
    source $CACHE_FILE_PATH
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

source "$SCRIPT_DIR/lib/colors.sh"

if [ -f ~/.cs-environment ]; then
    source ~/.cs-environment
fi

if [ -n $ADO_PAT ]; then
    NONINTERACTIVE=true
fi

GREETINGS=("Bonjour" "Hello" "Salam" "Привет" "Вітаю" "Hola" "Zdravo" "Ciao" "Salut" "Hallo" "Nǐ hǎo" "Xin chào" "Yeoboseyo" "Aloha" "Namaskaram" "Wannakam" "Dzień dobry")
GREETING=${GREETINGS[$RANDOM % ${#GREETINGS[@]} ]}

echo -e $PALETTE_WHITE"\n
        ~+

                 *       +
           '                  |
         +   .-.,=\"\`\`\"=.    - o -
             '=/_       \     |
          *   |  '=._    |   
               \     \`=./\`,        '
            .   '=.__.=' \`='      *
   +                         +
        O      *        '       .
"$PALETTE_RESET

echo -e $PALETTE_GREEN"\n\n     🖖 👽  $GREETING, Codespacer 👽 🖖\n"$PALETTE_RESET

if [ -z "$NONINTERACTIVE" ]; then
    sleep 1s
fi

echo -e $PALETTE_PURPLE"\n🏃 Lets setup the Codespace"$PALETTE_RESET

if [ -z "$NONINTERACTIVE" ]; then
    sleep 0.25s
fi

if [ -z "$VSCLK_REPO_URL" ]; then
    echo -e $PALETTE_RED"  🧱 VSCLK_REPO_URL is not defined. Exiting.."$PALETTE_RESET
    exit 1
fi

if [ -z "$CASCADE_REPO_URL" ]; then
    echo -e $PALETTE_RED"  🧱 CASCADE_REPO_URL is not defined. Exiting.."$PALETTE_RESET
    exit 1
fi

if [ -z "$ADO_PAT" ]; then
    echo -e $PALETTE_CYAN"Please provide your ADO PAT\n"$PALETTE_RESET

    # reading the PAT
    unset CHARCOUNT
    unset ADO_PAT_INPUT
    PROMPT=" ↳ PAT code[R/W] + packaging[R]: "

    stty -echo

    CHARCOUNT=0
    while IFS= read -p "$PROMPT" -r -s -n 1 CHAR
    do
        # Enter - accept password
        if [[ $CHAR == $'\0' ]] ; then
            break
        fi

        # Backspace
        if [[ $CHAR == $'\177' ]] ; then
            if [ $CHARCOUNT -gt 0 ] ; then
                CHARCOUNT=$((CHARCOUNT-1))
                PROMPT=$'\b \b'
                ADO_PAT_INPUT="${PASSWORD%?}"
            else
                PROMPT=''
            fi
        else
            CHARCOUNT=$((CHARCOUNT+1))
            PROMPT='*'
            ADO_PAT_INPUT+="$CHAR"
        fi
    done

    stty echo
    echo -e " "$PALETTE_RESET

    # check if PAT set
    if [ -z ${ADO_PAT_INPUT} ]; then
        echo -e $PALETTE_RED"\n  🐢  No PAT - Zero FLOPS per watt\n"$PALETTE_RESET
        exit 1
    fi

    export ADO_PAT=$ADO_PAT_INPUT

fi

export ADO_PAT_BASE64=$(echo -n $ADO_PAT | base64)

# replace env variable reference in the .npmrc
sed -i -E "s/_password=.+$/_password=$ADO_PAT_BASE64/g" ~/.npmrc

# cache tokens to env file
echo -e "export ADO_PAT=$ADO_PAT" >> ~/.cs-environment
echo -e "export ADO_PAT_BASE64=$ADO_PAT_BASE64" >> ~/.cs-environment

### Init each repo...

# Cascade
./.codespaces/setup-cascade.sh "force"
# VSclk
./.codespaces/setup-vsclk.sh "force"
# Create common sln file so you don't have to switch between solutions when working on different repos.
./.codespaces/generate-common-sln.sh

  echo -e "💡 $PALETTE_BOLD$PALETTE_GREEN Cloning finished!  \n$PALETTE_RESET    Open$PALETTE_BOLD agent-development.code-workspace$PALETTE_RESET and select$PALETTE_BOLD OPEN WORKSPACE$PALETTE_RESET.$PALETTE_RESET \n$PALETTE_RESET"


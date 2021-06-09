# Custom script inspired by the great tutorial from pstadler:
# https://github.com/pstadler/keybase-gpg-github

# Color stuff
red="\033[0;31m"
yellow="\033[0;33m"
green="\033[0;32m"
purple="\033[0;35m"
gray="\033[90m"
NC="\033[0m" # No Color


echo "${green}########################################"
echo "###   Install PGP key from Keybase   ###"
echo "########################################${NC}"

echo "${purple}\nReady to start? ${gray}(y/n)${NC}"
  read -r response </dev/tty
  if ! [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "${yellow} Not ready. Exiting...${NC}"
    exit 0
  fi

echo "${purple}Logging in to Keybase...${NC}"

{
  keybase login &&
  echo '\n'
  echo "${purple}Listing keys from Keybase:${NC}"
  keybase pgp list

  echo "${purple}Select the key you wish to import ${gray}<key> ${NC}"
  read -r response </dev/tty
  if [[ $response =~ ^([0-9 a-z]{70})$ ]]; then
    echo "${green}✅ Key selected. Importing public key from Keybase${yellow}"
    keybase pgp export -q $response | gpg --import-ownertrust
    echo '\n'
    echo "${green}✅ Public key imported"
    echo "${yellow}Importing secret key from Keybase..."
    echo "${gray}Waiting for input through Keybase prompt...\n${NC}"
    keybase pgp export -q $response --secret | gpg --allow-secret-key-import  --import-ownertrust

    gpgkey=`gpg --list-secret-keys --keyid-format LONG | perl -lne '/^sec[0-9 rsa]*\/([0-9A-Z]*)\s/ && print $1'`
    
    echo "\n${purple}Do you want to set the gpg key ${gray}($gpgkey)${purple} as signing key in global Git config? ${gray}(y/n)${NC}"
    read -r response </dev/tty
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      echo "${yellow} Setting as Git signing key...${NC}"

      git config --global user.signingkey $gpgkey
      git config --global commit.gpgsign true

      echo "${green} ✅ Git signingkey is set. Exiting.${NC}"
      exit 0
    fi
  fi
    echo "${yellow} ❌ No or invalid key selected. Exiting.${NC}"
    exit 0
} || {
  echo 'Keybase error. Exiting...'
}
############ Installations functions ############

function install_xcode_cli {
  echo "Installing Xcode CLI tools..."
  xcode-select --install;
}

function install_brew {
  echo "Installing Homebrew..."
  if !which brew 2>/dev/null; then
    ruby \
    -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" \
    </dev/null
    brew doctor
  else
    echo "Brew was already installed, upgrading"
    brew update;
    brew upgrade;
    brew prune
  fi
}

function install_brew_cask {
  echo "Installing Homebrew Cask..."
  brew cask > /dev/null 2>&1;
  if [ $? -ne 0 ]; then
    brew install caskroom/cask/brew-cask;
    brew cask doctor;
  else
    echo "Brew cask was already installed, upgrading"
    brew update;
    brew upgrade;
    brew prune
  fi
  brew tap caskroom/versions
}

function install_brew_deps {
  echo "Installing brew dependencies..."
  cat brew-requirements.txt | xargs brew install
  brew cleanup
  brew doctor
}

function install_brew_cask_deps {
  echo "Installing brew cask dependencies..."
  cat cask-requirements.txt | xargs brew cask install --appdir="/Applications"
  brew cleanup
  brew doctor
}

function setup_brew {
  echo "Setting up brew..."
  install_brew
  install_brew_cask
  install_brew_deps
  install_brew_cask_deps
}

function install_npm_globals {
  echo "Installing npm globals... using yarn."
  if hash yarn 2>/dev/null; then
    cat npm-global-requirements.txt | xargs sudo yarn global add
  fi
}

function install_python_globals {
  echo "Installing python globals..."
  cat python-global-requirements.txt | xargs sudo easy_install
}

function setup_mac {
  echo "✅ Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3 2>/dev/null

  echo "✅ Set a blazingly fast trackpad speed"
  defaults write -g com.apple.trackpad.scaling -int 5 2>/dev/null

  echo "✅ Automatically illuminate built-in MacBook keyboard in low light"
  defaults write com.apple.BezelServices kDim -bool true 2>/dev/null

  echo "✅ Turn off keyboard illumination when computer is not used for 5 minutes"
  defaults write com.apple.BezelServices kDimTime -int 300 2>/dev/null

  echo "✅ Disable the warning when changing a file extension"
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false 2>/dev/null

  echo "✅ Remove the auto-hiding Dock delay"
  defaults write com.apple.dock autohide-delay -float 0 2>/dev/null

  echo "✅ Automatically hide and show the Dock"
  defaults write com.apple.dock autohide -bool true 2>/dev/null

  echo "✅ Trackpad: enable tap to click for this user and for the login screen"
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true 2>/dev/null
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 2>/dev/null
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1 2>/dev/null

  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseOneFingerDoubleTapGesture -int 0
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseTwoFingerDoubleTapGesture -int 3
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseTwoFingerHorizSwipeGesture -int 2
  defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseButtonMode -string TwoButton
  defaults write ~/Library/Preferences/.GlobalPreferences.plist com.apple.mouse.scaling -float 3
  defaults write ~/Library/Preferences/.GlobalPreferences.plist com.apple.swipescrolldirection -boolean NO

  echo "✅ Keyboard: Make key repeat fast"
  defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
  defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

  echo "✅ Finder: Set column view for as default for all finder windows"
  defaults write com.apple.finder FXPreferredViewStyle Clmv

  echo "✅ Dock: Wipe all (default) app icons from the Dock"
  defaults write com.apple.dock persistent-apps -array
}

function setup_vs_code() {
  echo "Installing VS code libraries..."
  if hash code 2>/dev/null; then
    cat code-requirements.txt | xargs code --install-extension
  fi
}



############ Installations functions end ############



# Color stuff
red="\033[0;31m"
yellow="\033[0;33m"
green="\033[0;32m"
purple="\033[0;35m"
NC="\033[0m" # No Color

# echo "${red}Red text${NC}"
# echo "${yellow}Yellow text${NC}"
# echo "${green}Green text${NC}"
# echo "${purple}Purple text${NC}"

echo "###################################"
echo "###   Dotfiles installation   #####"
echo "###################################"

echo ""

# Get sudo from user
echo "You might need to input your sudo password"
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# OS spesifics
if [ "$(uname)" == "Linux" ]; then
	echo "\033[0;33m Environment detected as Linux \033[0m"
	sudo apt-get -y install coreutils curl zsh
elif [ "$(uname)" == "Darwin" ]; then
	
	echo "\033[0;33m Environment detected as macOS \033[0m"


	# Show hidden files
	echo "${purple}Show hidden files? (y/n)${NC}"
	read -r response </dev/tty
	if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
		echo "\033[0;33mChanging Finder settings to display hidden files \033[0m"
		defaults write com.apple.finder AppleShowAllFiles -boolean true && killall Finder
		echo "${green}Hidden files is now displayed in Finder${NC}"
	fi
	

	# Remove spotlight icon
	echo "${purple}Remove spotlight icon? (y/n) ${NC}"
	read -r response </dev/tty
	if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
		echo "\033[0;33mRemoving Spotlight icon \033[0m"
		sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
		echo "${green}Spotlight icon removed${NC}"
	fi
	
	# Fancy clock
	echo "${purple}Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window? (y/n) ${NC}"
	read -r response </dev/tty
	if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
		echo "\033[0;33mWorking on it.. \033[0m"
		sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
		echo "${green}OK${NC}"
	fi

	setup_mac;
	install_xcode_cli;
	setup_brew;
	install_npm_globals;
  setup_vs_code;
fi

install_python_globals;

# Install zsh
echo "\033[0;33m Checking if oh-my-zsh is installed.. \033[0m"

if [ ! -d ~/.oh-my-zsh ]; then
	echo "\033[0;33m Not installed \033[0m"
	echo "\033[0;33m Installing oh-my-zsh..\033[0m"
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	echo "${green}OK${NC}"
else
	echo "\033[0;33m oh-my-zsh already installed \033[0m"
fi


# Install fonts
echo "\033[0;33mInstalling fonts..\033[0m"
FONTS=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/fonts/rix1/*"

if [ ! -d ~/.fonts ]; then
	mkdir ~/.fonts
fi

for file in $FONTS
do
	if [ "$(uname)" == "Linux" ]; then
		cp $file ~/.fonts/
	else
		cp $file ~/Library/Fonts/
	fi
	echo "\033[0;33m $file installed \033[0m"
done
echo "${green}OK${NC}"


#Install theme
echo "\033[0;33mInstalling theme (remy)..\033[0m"
THEME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/themes/remy.zsh-theme"
ln -sf $THEME ~/.oh-my-zsh/themes/remy.zsh-theme
echo "${green}OK${NC}"

# Syntax highlighting
echo "\033[0;33m Setting up syntax highlighting.. \033[0m"
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
	echo "\033[0;33m Not installed \033[0m"
	echo "\033[0;33mInstalling syntax highlighting..\033[0m"
	cd ~/.oh-my-zsh/custom/plugins && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git 
	cd $CURRENT_DIR
	echo "${green}OK${NC}"

else
	echo "\033[0;33m oh-my-zsh already installed \033[0m"
fi


# Setup of dotfiles in home dir

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )           # dotfiles directory
olddir=~/dotfiles_old             								# old dotfiles backup directory
files="zshrc vimrc screenrc scripts aliases dir_colors"    		# list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo "\033[0;33m Creating $olddir for backup of any existing dotfiles in ~ \033[0m"
mkdir -p $olddir
echo "${green}Done!${NC}"

# change to the dotfiles directory
echo "\033[0;33m Changing to the $dir directory \033[0m"
cd $dir
echo "${green}Done!${NC}"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
	echo "\033[0;33m Moving any existing dotfiles from ~ to $olddir \033[0m"
	mv ~/.$file ~/dotfiles_old/
	echo "\033[0;33m Creating symlink to $file in home directory. \033[0m"
	ln -s $dir/$file ~/.$file
done


# Add Z to ~ if on linux
if [ "$(uname)" == "Linux" ]; then
	ln -sf $dir/scripts/z.sh ~/.z.sh
fi

# Check for private aliases, add if exists
if [ -f $dir/private_aliases ]; then
	ln -sf $dir/private_aliases ~/.private_aliases
fi


echo "${red}Please restart the machine for all changes to take effect${NC}"


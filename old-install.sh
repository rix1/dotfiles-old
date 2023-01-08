red="\033[0;31m"
yellow="\033[0;33m"
green="\033[0;32m"
purple="\033[0;35m"
NC="\033[0m" # No Color

############ Installations functions ############

function install_brew {
  echo "Installing Homebrew..."
	if ! which brew > /dev/null; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		echo '# Set PATH, MANPATH, etc., for Homebrew.' >> ~/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew doctor;
  else
    echo "Brew was already installed, upgrading"
    brew update;
    brew upgrade;
  fi
}

function install_brew_deps {
  echo "Installing brew dependencies..."
  cat ./requirements/brew.txt | xargs brew install
  brew cleanup
  brew doctor
}

function install_brew_cask_deps {
  echo "Installing brew (cask) dependencies..."
  cat ./requirements/cask.txt | xargs brew install --appdir="/Applications"
  brew cleanup
  brew doctor
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


function setup_brew {
  echo "Setting up brew..."
  install_brew
  install_brew_deps
  install_brew_cask_deps
}

############ Installations functions end ############

echo "###################################"
echo "###   Dotfiles installation   #####"
echo "###################################\n"

# Get sudo from user
echo "You might need to input your sudo password"
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "${yellow} This only works for macOS ${NC}"


# Show hidden files
echo "${purple}Show hidden files? (y/n)${NC}"
read -r response </dev/tty
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
	echo "${yellow}Changing Finder settings to display hidden files ${NC}"
	defaults write com.apple.finder AppleShowAllFiles -boolean true && killall Finder
	echo "${green}Hidden files is now displayed in Finder${NC}"
fi

setup_mac;
setup_brew;


echo "${yellow} ========== THATS IT FOR DEPS!  =========="

echo "=== Will continue with configuration... === ${NC}"

dotfiles_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )       # dotfiles directory
mkdir -p ~/.config # this is required by a lot of stuff below

# Install fish
echo "${yellow} Checking if Fish is installed.. ${NC}"

if [ ! $(which fish) ]; then
	echo "${yellow} Fish not installed ${NC}"
  brew install fish
  echo "✅ Fish installed. Installing Fisher plugin manager..."
  curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
  echo "✅ Fisher installed. Installing dependencies from /requirements/fish.txt..."
  cat ./requirements/fish.txt | xargs fisher install
  echo "✅ All Fisher plugins installed."

	echo "${yellow} Creating symlinks to Fish config files...${NC}"

  ln -sf $dotfiles_dir/config/fish/config.fish $HOME/.config/fish/config.fish
  ln -sf $dotfiles_dir/config/fish/aliases.fish $HOME/.config/fish/aliases.fish

	echo "${green}✅ OK - Fish (and Fisher) is installed and configured${NC}"
else
	echo "${yellow} Fish shell already installed ${NC}"
fi

# Install fonts
echo "${yellow}Installing fonts..${NC}"
fonts_dir=$( cd "$( dirname "$0" )" && pwd )"/fonts"
find_command="find \"$fonts_dir\" \( -name '*.[o,t]tf' -or -name '*.pcf.gz' \) -type f -print0"

font_dir="$HOME/Library/Fonts"
eval $find_command | xargs -0 -I % cp "%" "$font_dir/"
echo "${green}OK${NC}"


# Set up configuration
echo "${yellow} Setting up starship prompt ${NC}"
ln -s $dotfiles_dir/config/starship.toml $HOME/.config/


# change to the dotfiles directory
echo "${yellow} Changing to the $dotfiles_dir directory ${NC}"
cd $dotfiles_dir
echo "${green}Done!${NC}"

files=".vimrc dir_colors .gitconfig .gitignore .editorconfig"    	# list of files/folders to symlink in homedir
# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks
for file in $files; do
	echo "${yellow} Creating symlink to $file in home directory. ${NC}"
	ln -s $dotfiles_dir/$file ~/$file
done


echo "${red}Please restart the machine for all changes to take effect${NC}"


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
	
	echo "\033[0;33m Environment detected as OSX \033[0m"


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

	echo "${purple}Use column view in all Finder windows by default? (y/n)${NC}"
	read -r response </dev/tty
	if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
		defaults write com.apple.finder FXPreferredViewStyle Clmv
		echo "${green}OK${NC}"
	fi

	echo "${purple}Wipe all (default) app icons from the Dock? (y/n)${NC}"
	read -r response </dev/tty
	if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  		defaults write com.apple.dock persistent-apps -array
  		echo "${green}OK${NC}"
	fi


	# Install brew
	echo "\033[0;33m Checking if Homebrew is installed.. \033[0m"
	echo "${red}Homebrew wil be installed if it is not already done${NC}"
	if ! which brew > /dev/null; then
		echo "\033[0;33m Homebrew not installed \033[0m"
		echo "\033[0;33mInstalling Homebrew.. \033[0m"
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		echo "\033[0;33m Running brew doctor.. \033[0m"
		brew doctor
		echo "${green}OK${NC}"
	else
		echo "\033[0;33m Homebrew already installed \033[0m"
	fi

	# Install brew packages
	echo "\033[0;33mVerifying that necessary Homebrew packages are installed\033[0m"
	brew install coreutils wget z
	echo "${green}OK${NC}"

	# Install brew packages
	echo "\033[0;33mInstalling additional user packages\033[0m"
	brew install ffmpeg nmap htop-osx imagemagick jenv node tree yarn
	echo "${green}OK${NC}"

	# Install brew cask software
	echo "\033[0;33mInstalling Rix1 software. This might take a while\033[0m"
	brew install cask
	brew cask install dropbox adobe-creative-cloud harvest spectacle android-file-transfer imageoptim spotify nvalt textmate firefox atom notational-velocity sublime-text numi quicksilver google-Ωchrome slack
	echo "${green}OK${NC}"
fi


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


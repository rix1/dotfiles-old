echo "\033[0;33m Dotfiles installation \033[0m"


# OS spesifics
if [ "$(uname)" == "Linux" ]; then
	echo "\033[0;33m Environment detected as Linux \033[0m"
elif [ "$(uname)" == "Darwin" ]; then
	# Show hidden files
	echo "\033[0;33m Environment detected as OSX \033[0m"
	echo "\033[0;33mChanging Finder settings to display hidden files \033[0m"
	defaults write com.apple.finder AppleShowAllFiles -boolean true
	killall Finder

	# Install brew
	echo "\033[0;33m Checking if Homebrew is installed.. \033[0m"
	if ! which brew > /dev/null; then
		echo "\033[0;33m Homebrew not installed \033[0m"
		echo "\033[0;33mInstalling Homebrew.. \033[0m"
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		echo "\033[0;33m Running brew doctor.. \033[0m"
		brew doctor
	else
		echo "\033[0;33m Homebrew already installed \033[0m"
	fi

	# Install brew packages
	echo "\033[0;33mVerifying that necessary Homebrew packages are installed\033[0m"
	brew install coreutils wget z
fi


# Install zsh
echo "\033[0;33m Checking if oh-my-zsh is installed.. \033[0m"

if [ ! -d ~/.oh-my-zsh ]; then
  echo "\033[0;33m Not installed \033[0m"
  echo "\033[0;33mInstalling oh-my-zsh..\033[0m"
  curl -L http://install.ohmyz.sh | sh
else
	echo "\033[0;33m oh-my-zsh already installed \033[0m"
fi


# Install fonts
echo "\033[0;33mInstalling fonts..\033[0m"
FONTS=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/fonts/*"

for file in $FONTS
do
	cp $file ~/Library/Fonts/
	echo "\033[0;33m $file installed \033[0m"
done


# Install theme
echo "\033[0;33mInstalling theme (remy)..\033[0m"
THEME=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/themes/remy.zsh-theme"
ln -sf $THEME ~/.oh-my-zsh/themes/remy.zsh-theme

# Syntax highlighting
echo "\033[0;33m Setting up syntax highlighting.. \033[0m"
if [ ! -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
  echo "\033[0;33m Not installed \033[0m"
  echo "\033[0;33mInstalling syntax highlighting..\033[0m"
  CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
  cd ~/.oh-my-zsh/custom/plugins && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git 
  cd CURRENT_DIR

else
	echo "\033[0;33m oh-my-zsh already installed \033[0m"
fi


# Setup of dotfiles in home dir

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )           # dotfiles directory
olddir=~/dotfiles_old             								# old dotfiles backup directory
files="zshrc vimrc screenrc scripts aliases"    				# list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo "\033[0;33m Creating $olddir for backup of any existing dotfiles in ~ \033[0m"
mkdir -p $olddir
echo "\033[0;33m Done! \033[0m"

# change to the dotfiles directory
echo "\033[0;33m Changing to the $dir directory \033[0m"
cd $dir
echo "\033[0;33m Done! \033[0m"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    echo "\033[0;33m Moving any existing dotfiles from ~ to $olddir \033[0m"
    mv ~/.$file ~/dotfiles_old/
    echo "\033[0;33m Creating symlink to $file in home directory. \033[0m"
    ln -sf $dir/$file ~/.$file
done



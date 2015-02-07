printf "======Dotfiles installation===== \n"


# Install brew
printf "Checking if Homebrew is installed.. \n"
if ! which brew > /dev/null; then
	printf "Homebrew not installed \n"
	printf "Installed Homebrew.. \n"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	echo "Running brew doctor.."
	brew doctor
else
	printf "Homebrew already installed \n"
fi


# Install brew packages
echo "Verifying that necessary Homebrew packages are installed"
brew install coreutils wget z


# Install zsh
printf "Checking if oh-my-zsh is installed.. \n"

if [ ! -d "~/.oh-my-zsh" ]; then
  printf "Not installed \n"
  printf "Installing oh-my-zsh.. \n"
  curl -L http://install.ohmyz.sh | sh
else
	printf "oh-my-zsh already installed \n"
fi


# Install fonts
echo "Installing fonts.."
FONTS=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/fonts/*"

for file in $FONTS
do
	cp $file ~/Library/Fonts/
	echo "$file installed"
done


# Install theme


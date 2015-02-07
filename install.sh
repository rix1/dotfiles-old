printf "======Dotfiles installation===== \n"

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

echo "Verifying that necessary Homebrew packages are installed"
brew install coreutils wget z



printf "Checking if oh-my-zsh is installed.. \n"

if [ ! -d "oh-my-zsh" ]; then
  printf "Not installed \n"
  printf "Installing oh-my-zsh.. \n"
  git clone https://github.com/robbyrussell/oh-my-zsh.git
else
	printf "oh-my-zsh already installed \n"
fi
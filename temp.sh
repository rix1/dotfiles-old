dotfiles_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )       # dotfiles directory
# change to the dotfiles directory
echo "${yellow} Changing to the $dotfiles_dir directory ${NC}"
cd $dotfiles_dir
echo "${green}Done!${NC}"

mkdir $HOME/.config/fish
ln -sf $dotfiles_dir/config/fish/config.fish $HOME/.config/fish/config.fish
ln -sf $dotfiles_dir/config/fish/aliases.fish $HOME/.config/fish/aliases.fish

set -x LANG en_US.UTF-8
set -x GPG_TTY (tty)
set -gx EDITOR subl

starship init fish | source

source $HOME/.config/fish/aliases.fish

fzf_configure_bindings --git_log=\cl --directory=\cf

# set fish_user_paths /Users/rikardeide/Library/Python/3.9/bin $fish_user_paths

set -x ANDROID_HOME $HOME/Library/Android/sdk
set -U fish_user_paths $HOME/Library/Android/sdk/platform-tools $fish_user_paths

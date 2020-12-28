# Path to your oh-my-zsh installation.
zmodload zsh/zprof

export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="remy"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='/Applications/Sublime Text.app/Contents/MacOS/Sublime Text'
# fi


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.


# Python environment autosource
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH=/usr/local/share/python:$PATH


# export PYENV_ROOT=/usr/local/bin/pyenv
# if which pyenv > /dev/null; then
#     eval "$(pyenv init -)"
# fi


# Aliases
source ~/.aliases/main

# Check if user has private aliases as well
if [ -f ~/.private_aliases ]; then
	source ~/.private_aliases
fi

# OS spesifics
if [ "$(uname)" '==' "Darwin" ]; then
	source ~/.aliases/osx
	# Z
	. `brew --prefix`/etc/profile.d/z.sh
	# Dircolors
	eval `gdircolors ~/.dir_colors`
	alias ls='gls --color'
fi

# Dircolors
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Old prompt? not sure if needed
# autoload -Uz compinit
# compinit

# Pure
# autoload -U promptinit; promptinit
# prompt pure

# Starhip
eval "$(starship init zsh)"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# Remember that zsh-syntax-highlighting must be last!!
plugins=(git brew zsh-syntax-highlighting)


## Tiny Care Terminal https://github.com/notwaldorf/tiny-care-terminal

# List of accounts to read the last tweet from, comma separated
# The first in the list is read by the party parrot.
export TTC_BOTS='tinycarebot,selfcare_bot,magicrealismbot'

# List of folders to look into for `git` commits, comma separated.
export TTC_REPOS='/Users/rikardeide/Development'
export TTC_REPOS_DEPTH=2

export TTC_SAY_BOX=parrot

# Location/zip code to check the weather for. Both 90210 and "San Francisco, CA"
# should be ok. It's using weather.service.msn.com behind the curtains.
export TTC_WEATHER='Oslo'

# Unset this if you _don't_ want to use Twitter keys and want to
# use web scraping instead.
export TTC_APIKEYS=false

export ANDROID_HOME="/usr/local/share/android-sdk"

# Issue with GPG solved with this:
export GPG_TTY=$(tty)

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi


source $ZSH/oh-my-zsh.sh

# fzf is a general-purpose command-line fuzzy finder.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fnm and shell
eval `fnm env`



export JAVA_HOME=/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="/usr/local/sbin:$PATH"
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/12/bin/

export PASSWORD_STORE_DIR=~/.password-store/

# 2020-11-11 11:38 Needed to get psycopg2 working!
export LIBRARY_PATH="$LIBRARY_PATH:/usr/local/opt/openssl@1.1/lib/"

# Annoying thing on Heroku shell
export DD_TRACE_STARTUP_LOGS="false"


eval "$(gh completion -s zsh)"

if command -v pyenv 1>/dev/null 2>&1; then
	eval "$(pyenv init -)"
fi

# if which pyenv-virtualenv-init > /dev/null; then
# 	eval "$(pyenv virtualenv-init -)";
# fi

# source ~/.scripts/detect_virtualenvs.sh
# source /usr/local/bin/virtualenvwrapper.sh

export PATH="$HOME/.poetry/bin:$PATH"

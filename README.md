### What

![result](http://i.imgur.com/FAgPZ6N.png)

## Fonts

- Vscode: Dank Mono, FiraCode Nerd Font, Menlo, Monaco, Courier New, monospace
- iTerm: FiraCode Nerd Font

Resources:

- https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode

### How

1. Install iTerm2

2. Install Command line tools

`xcode-select --install`

3. Clone repo to home directory

`git clone https://github.com/rix1/dotfiles.git`

4. Run install script

On OS X

`cat install.sh | sh`

On Linux

`bash install.sh`

5. Apply iTerm theme and settings

Settings is located at `./iterm-preferences/com.googlecode.iterm2.plist`

6. Restart iTerm

7. Install fonts:

`git clone https://github.com/powerline/fonts.git`

8. Fix insecure files:

`compaudit | xargs chmod g-w`

8. (optional) Setup gpg by installing PGP keys from Keybase

`cat setup-gpg.sh | sh`

### Troubleshooting

- Is is something wrong with the fonts? Try `echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"`. This should look like this ![Icons](./characters.png)
- Shell is not loading? Remember to change shell to `zsh` using `chsh -s $(which zsh)`.
- Remember to [init a git folder](https://git-scm.com/docs/git-config#_conditional_includes) in /Development/work/

### Private aliases

If you have any extra aliases, you can put them in a file called `private_aliases` inside the dotfiles directory. That file will then automatically be sourced.

Inspired by https://remysharp.com/2013/07/25/my-terminal-setup

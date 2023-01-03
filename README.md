### What

![result](http://i.imgur.com/FAgPZ6N.png)

## Fonts

- Vscode: Dank Mono, FiraCode Nerd Font, Menlo, Monaco, Courier New, monospace
- iTerm: FiraCode Nerd Font

Note: Only Dank mono is included in this repo. You need to install the others separately:

- https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode

### How

1. Install Command line tools

`xcode-select --install`

2. Clone repo to home directory

`git clone https://github.com/rix1/dotfiles.git`

3. Run install script (OSX only)

`cat install.sh | sh`

4. Apply iTerm theme and settings

Settings is located at `./iterm-preferences/com.googlecode.iterm2.plist`

5. Restart iTerm

6. Fix insecure files:

`compaudit | xargs chmod g-w`

7. (optional) Setup gpg by installing PGP keys from Keybase

`cat setup-gpg.sh | sh`

### Troubleshooting

- Is is something wrong with the fonts? Try `echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"`. This should look like this ![Icons](./characters.png)
- Shell is not loading? Remember to change shell to `zsh` using `chsh -s $(which zsh)`.
- Remember to [init a git folder](https://git-scm.com/docs/git-config#_conditional_includes) in /Development/work/ to commit from correct email addrsss.



### New guide


- Add `/opt/homebrew/bin/fish` to `/etc/shells`

Ditch the PGP import script. Use this instead: https://blog.scottlowe.org/2017/09/06/using-keybase-gpg-macos/
- Authenticate with Github using GH
### What

![result](http://i.imgur.com/FAgPZ6N.png)

### How

1. Install iTerm2

2. Install Command line tools

```xcode-select --install```

3. Clone repo to home directory

```git clone https://github.com/andrroy/dotfiles.git```

4. Run install script

On OS X

```cat install.sh | sh```

On Linux

```bash install.sh```

5. Apply iTerm theme

6. Restart iTerm

7. Install fonts:

```git clone https://github.com/powerline/fonts.git```

8. Fix insecure files:

```compaudit | xargs chmod g-w```


### Troubleshooting

Is is something wrong with the fonts? Try `echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"`. This should look like this ![Icons](./characters.png)


### Private aliases
If you have any extra aliases, you can put them in a file called ```private_aliases``` inside the dotfiles directory. That file will then automatically be sourced.  

Inspired by https://remysharp.com/2013/07/25/my-terminal-setup
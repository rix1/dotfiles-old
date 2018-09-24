const globalGitIgnore = `# Created by https://www.gitignore.io/api/macos

### macOS ###
*.DS_Store
.AppleDouble
.LSOverride

# Icon must end with two \r
Icon

# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

# End of https://www.gitignore.io/api/macos


.vscode/
# .vscode/settings.json
# .vscode/tasks.json
# .vscode/launch.json
# .vscode/extensions.json
`

const gitconfig = `
[user]
    email = rix1@otovo.com
    name = Rikard Eide
	signingkey = 50980AB2C75D059E
[core]
[commit]
	gpgsign = true
[alias]
	co = checkout
	br = branch
	ci = commit
	st = status
	s = show
	loga = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'
	logf = git log --name-only
	diffc = diff --cached
[core]
	excludesfile = /Users/rikardeide/.gitignore_global
[rebase]
	autoSquash = true
`
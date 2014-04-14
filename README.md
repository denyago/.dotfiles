# Initial Setup

From _this_ directory.

0. Install Xcode command line developer tools `xcode-select --install`
1. Install brew: `ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"`
2. Install RVM: `\curl -sSL https://get.rvm.io | bash -s stable && source ~/.rvm/scripts/rvm`
3. Install brew-cask: `brew install phinze/cask/brew-cask && brew cask --help`
4. Install software: `brew bundle`
5. Install OhMyZSH: `curl -L http://install.ohmyz.sh | sh`
6. Run OS X setup script: `./osx-setup.sh`

# Tips

1. Run PostgreSQL manually `LC_ALL=en-US.utf8 postgres -D /usr/local/var/postgres`

# TODO

Automate with Boxen. 
  * https://github.com/boxen/boxen-web   - to deliver
  * https://github.com/denyago/our-boxen - to get settings and so on
  
# Links

https://gist.github.com/millermedeiros/6615994
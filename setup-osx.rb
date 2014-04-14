#!/usr/bin/env ruby

##
# Determines way of installing Xcode Command Line Tools for OS X 10.8+
# 
# Example:
#
#   OSXToolsInstaller.new.install!
#
# Borrowed from https://github.com/boxen/boxen-web/blob/b26abd0d681129eba0b5f46ed43110d873d8fdc2/app/views/splash/script.sh.erb
class OSXToolsInstaller

  # Triggers CLI Tools installation or exits with code '1'.
  def install!
    if cli_tools_installed?
      puts 'Looks like Xcode/CLI Tools are already installed'
    else
      case osx_version 
        when '10.8' then install_for_108
        when '10.9' then install_for_109
        else fail_install
      end
    end
  end

  private

  # Returns String with OS X version. If it's not possible to determine - string is blank.
  def osx_version
    @osx_version ||= `sw_vers | grep ProductVersion | cut -f 2 -d ':'  | awk ' { print $1; } '`.strip rescue ''
  end

  def cli_tools_installed?
    File.exists?('/usr/bin/gcc')
  end

  def fail_install
    puts "Your OS X version is '#{osx_version}', but it must be Mountain Lion or greater!"
    exit 1
  end

  def install_for_108
    puts "
Since you are running OS X 10.8, you will need to install Xcode and the
Command Line Tools to continue.

  1. Go to the App Store and install Xcode.
  2. Start Xcode.
  3. Click on Xcode in the top left corner of the menu bar and click on
     Preferences.
  4. Click on the Downloads tab.
  5. Click on the Install button next to Command Line Tools.'
"
    wait_for_tools_installed
  end

  def install_for_109
    puts "
Since you are running OS X 10.9, you will need to install the Command
Line Tools.

  1. You should see a pop-up asking you to install them in a moment.
  2. Click Install!'
"
    wait_for_tools_installed
  end

  def wait_for_tools_installed
    puts "While you are installing them, I'll wait... or hit Ctrl+C to stop me."
    while not cli_tools_installed?
      sleep 60
    end
  end
end

##
# Installs required utilities.
#
# Example:
#   
#   utils = [
#     { :name => 'Util 1', :command => 'install_util_1', :check => 'which util_1' }
#   ]
#   UtilsInstaller.new(utils).install!
class UtilsInstaller
  def install!
    @targets.each do |target|
      puts "Installing #{target[:name]}"
      install_target(target[:command], target[:check])
    end
  end

  private

  def initialize(utils_list)
    @targets = utils_list.dup 
  end

  def install_target(install_cmd, check_cmd)
    unless check_cmd.nil?
      `#{check_cmd}`
      if $?.exitstatus.zero?
        puts '... already installed'
        return
      end
    end

    system(install_cmd)
    if $?.exitstatus.zero?
      puts '... installed'
    else
      puts '... failed to install'
    end
  end
end

targets = [
  {
    :name    => 'Homebrew',  
    :command => 'ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"',
    :check   => 'brew --version'
  },
  {
    :name    => 'RVM',       
    :command => 'curl -sSL https://get.rvm.io | bash -s stable && source ~/.rvm/scripts/rvm',
    :check   => 'rvm --version'
  },
  {
    :name    => 'Brew Cask', 
    :command => 'brew install phinze/cask/brew-cask && brew cask --help',
    :check   => 'brew list | grep cask'
  },
  { 
    :name    => 'Brew and Cask packages', 
    :command => 'brew bundle'
  },
  { 
    :name    => 'OhMyZSH',   
    :command => 'curl -L http://install.ohmyz.sh | sh',
    :check   => 'ls ~/.oh-my-zsh'
  },
  { 
    :name    => 'OS X fine-tuning',
    :command => './osx-fine-tuning.sh'
  }
]

OSXToolsInstaller.new.install!
UtilsInstaller.new(targets).install!

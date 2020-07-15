# detect OS
OS=`uname -s`

# zsh magic completion
# Re-enabled after fixing fpath in .zshenv:
autoload -zU compinit
compinit

# command prompt
export PROMPT='%2~> '
setopt promptpercent
if [[ "$USER" = "aria" && -o login ]] && id ariashell &>/dev/null; then
  exec sudo -u ariashell -s
elif [[ "$USER" = "aria" ]] && id ariashell &>/dev/null; then
  export PROMPT='%2{❗️%} %2~> '
elif [[ "$USER" = "aria" ]]; then
  export PROMPT='%2{%(0?.❤️ .💔)%} %2~> '
elif [[ "$USER" = "ariashell" ]]; then
  export PROMPT='%2{%(0?.💖.🧡)%} %2~> '
else
  export PROMPT='%2{‼️ %} ERR:%n>'
fi

if id homebrew &>/dev/null; then
  brew() {
    sudo -u homebrew -i zsh -c "cd '$(pwd)'; brew $*"
  }
fi

function ado {
  if [[ "$*" = "" ]]; then
    su aria
  else
    su aria -c "$*"
  fi
}
function revan {
  if [[ "$*" = "" ]]; then
    su revan -c "zsh"
  else
    su revan -c "$*"
  fi
}

# Zsh options
# roughly alias cd=pushd:
setopt autopushd
alias pd=popd

# vim style history with up/down
# https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^P' up-line-or-beginning-search
bindkey '^N' down-line-or-beginning-search
bindkey '^U' backward-word
bindkey '^O' forward-word
# old sort-of vim style history with shift-up/down\pageup/down
#bindkey "\033[5~" history-beginning-search-backward
#bindkey "\033[6~" history-beginning-search-forward

# case insensitive tabbing
# OLD zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete # _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME/.local/zsh_history"
touch "$HISTFILE"
chmod 600 "$HISTFILE"

# hack to make mac git complete fast
__git_files () { 
	_wanted files expl 'local files' _files
}

# OS-Specific things (ls colors etc)
if [ $OS = 'Linux' ]; then
  eval "$(dircolors -b)"
	ls_color='--color=auto'
fi

if [ $OS = 'Darwin' ]; then
	ls_color='-G'
	alias -r valgrind='valgrind --dsymutil=yes'
	alias -r tailf='tail -f'

	# Set Apple Terminal.app resume directory
	# http://superuser.com/questions/313650/resume-zsh-terminal-os-x-lion
	if [[ $TERM_PROGRAM == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]]
	{
		function chpwd
		{
			local SEARCH=' '
			local REPLACE='%20'
			local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
			printf '\e]7;%s\a' "$PWD_URL"
		}
		chpwd
	}
	alias chrome='open /Applications/Google\ Chrome.app'
	alias preview='open /Applications/Preview.app'
	alias safe='xattr -rd com.apple.quarantine'
	alias xcode_enableindexing='defaults write com.apple.dt.XCode IDEIndexDisable 0'
	alias xcode_disableindexing='defaults write com.apple.dt.XCode IDEIndexDisable 1'
fi

# aliases
alias -r ls="ls $ls_color"
alias -r cim='vim'
alias -r vm='vim'
alias -r make='make --warn-undefined-variables'
alias -r valgrindall='valgrind --trace-children=yes'
alias -r valgrindallq='valgrind --trace-children=yes --quiet'
alias -r src='source ~/.zshenv && source ~/.zshrc && rehash'
svnlog() { svn log $@ --verbose | less; }
xarg() { while read arg ; do ; $@ "$arg" ; done }
alias -r l="ls $ls_color"
alias -r c="cd"
alias -r m="make --warn-undefined-variables"
alias -r vi="vim"
lg() { ls | grep -i -e $@ | xargs ls -G; }
alias -r viewer='view -'
alias -r vim='vim -p'
# Open file(s) with name matching regex:
vif() { vim -p -- $(find . -type f | grep $@) }
vifa() { vim -p -- $(find . -type f | grep $@) }
# Open file(s) with content matching regex:
vig() { vim +1 -c '\\v'"$*" -- $(git grep -l "$*") }
# Alias vim-style space+o to vif
alias o=vif

# git aliases
alias -r g='git'
gd() { git diff $@ | vim -R - }
gf() { git fetch && git stash && git rebase $@ && git stash pop }
gl() { git log $@ | less }
glv() { git log --name-status $@ | less }
alias -r gci='git commit'
alias -r gco='git checkout'
alias -r ga='git add'
alias -r gs='git status'
alias -r gb='git branch'

# Set up command line mode (currently vim mode...)

# Add -- COMMAND -- message when in command mode
# http://superuser.com/questions/151803/how-do-i-customize-zshs-vim-mode
function zle-line-init zle-keymap-select {
	RPS1="${${KEYMAP/vicmd/-- COMMAND --}/(main|viins)/}"
	RPS2=$RPS1
	zle reset-prompt
}
#zle -N zle-line-init
#zle -N zle-keymap-select

# fix backspace key
bindkey '^?' backward-delete-char

# And key bindings
# https://bbs.archlinux.org/viewtopic.php?pid=428669

# Java settings
alias setjava7='source setjava7.sh'

# Ruby & Rails settings
# rbenv:
# if command -v rbenv >/dev/null; then
#   eval "$(rbenv init - zsh)"
# fi

# pyenv
if command -v pyenv >/dev/null; then
  pyenv rehash
fi

# bundle exec rails fanciness
function r {
    bundle exec rails "$@"
}

function rcap {
    bundle exec cap "$@"
}

function rk {
    bundle exec rake "$@"
}

alias -r rc='rlwrap bundle exec rails console'

function remount {
    sudo kextunload -b com.apple.driver.AppleSDXC
    sudo kextload -b com.apple.driver.AppleSDXC
}

# ssh identity stuff
function identify {
    if [ -z "$SSH_AGENT_PID" ]; then
        eval `ssh-agent -s`
        eval ssh-add
    fi
}
alias yarn="identify && yarn"

export APACHE_CONFIG="/private/etc/apache2/httpd.conf"
export APACHE_VHOSTS="/private/etc/apache2/extra/httpd-vhosts.conf"

function path {
  echo $PATH | tr ':' '\n'
}

# https://sidneyliebrand.io/blog/how-fzf-and-ripgrep-improved-my-workflow#installing-brew-plugins
# https://github.com/junegunn/fzf
#export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!/.git/'"
export FZF_DEFAULT_OPTS="--exact --reverse --tiebreak=length,end --color=16"

# Node
export NODE_REPL_HISTORY="$HOME/.local/.node_repl_history"

# Json tricks (https://news.ycombinator.com/item?id=20245913)
# Writing https://github.com/tomnomnom/gron in jq
function gron {
  # Pass stdin or $1 as the file, if specified:
  if (( $# == 0 )) ; then cat - ; else cat $1 ; fi | jq -r --stream '
    select(length > 1)
    | (
      .[0] | map(
        if tostring | test("^[A-Za-z$_][0-9A-Za-z$_]*$")
        then "." + .
        else "[" + @json + "]"
        end
      ) | add
    )
    + " = "
    + (.[1] | @json)
  '
}
function ungron {
  # Add ' |' to every line, add '.' to the last line,
  # then pass that input as the program to jq, to operate
  # on a default null/empty object
  sed -e 's/$/ |/' -e '$s/$/./' | jq -nf /dev/stdin
}

function hi {
  local hour="$(date +%H)"
  local name
  id -F | read -r -d ' ' name
  local partOfDay
  local message
  if [[ $hour -lt 6 ]]; then
    partOfDay='night'
    message="Please set yourself up for sleep before you get tired 🌌!"
  elif [[ $hour -lt 12 ]]; then
    partOfDay='morning'
    message="Hope you've got some tea 🍵!"
  elif [[ $hour -lt 18 ]]; then
    partOfDay='afternoon'
    message="Please remember to take a step back and decide what to do next 💖~"
  elif [[ $hour -lt 21 ]]; then
    partOfDay='evening'
    message="What's something you're proud of about today? 🎀"
  else
    partOfDay='night'
    message="Please go to bed 🌌!"
  fi

  echo "Good ${partOfDay}, ${name}. ${message}"
}

# Current work:
#export webapp="$HOME/depot/mcam/MagicCameraServer/mcserver/webapp"
#export drawing_tool="$HOME/depot/mcam/MagicCameraServer/mcserver/webapp/app/js/app/react/creative_tools/drawing_tool"
#export family_app="$HOME/depot/mcam/MagicCameraServer/mcserver/webapp/app/js/app/react/family_app"
#export seesaw_library="$HOME/depot/mcam/MagicCameraServer/mcserver/webapp/app/js/shared/react/library"
#export library="$seesaw_library"

# Pilot dotfiles/shared_terminal_file:

if [[ -d "$HOME/pilot" ]]; then
  export PILOT_HOME="$HOME/pilot"
fi
if [[ -d $HOME/pilot/zapgram ]]; then
  export PILOT_ZAPGRAM="$HOME/pilot/zapgram"
fi
if [[ -d $HOME/pilot/connections ]]; then
  export PILOT_CONNECTIONS="$HOME/pilot/connections"
fi
if [[ -d $HOME/pilot/dotfiles ]]; then
  export PILOT_DOTFILES="$HOME/pilot/dotfiles"
  export PSQLRC="$PILOT_DOTFILES/.psqlrc"
fi

############## SETTING UP ##########################

# Set up functions for switching between your local environment, your staging
# environment, and the shared e2e environment.
#   - For now, almost all work (local, staging, and prod) happens in aws_prod.
#   - The pilottesting environment is a shared credential for all testing through Travis
pilot_local() {
    export PILOT_ENVIRONMENT=local;
    export AWS_PROFILE=pilotprod;
}
pilot_staging() {
    export PILOT_ENVIRONMENT=staging;
    export AWS_PROFILE=pilotprod;
}
pilot_e2e() {
    export PILOT_ENVIRONMENT=e2e;
    export AWS_PROFILE=pilottesting;
}
pilot_unset() {
    unset PILOT_ENVIRONMENT;
    unset AWS_PROFILE;
}
# Don't make an alias for PILOT_ENVIRONMENT=PRODUCTION. This should be harder to do.


# Run this command basically every time you open a new Pilot terminal
#   - Go to the zapgram directory
#   - Default to a local development environment
#   - Activate the zapgram virtual environment
zgs() {
    cd "${PILOT_ZAPGRAM}";
    . .ve/bin/activate;
    pilot_local;
}


############## OCCASIONAL COMMANDS #################

# Set up a function to add your IP address to the AWS ingress rules
#   - If you have PILOT_ENVIRONMENT set to local, staging, or e2e,
#     this will add your IP to AWS region us-west-1
#   - If you have PILOT_ENVIRONMENT set to PRODUCTION,
#     this will force you to confirm that you really want
#     production then add your IP to AWS region us-west-2
pilot_work_remotely() {
    zg deployment --task=connect;
}
pilot_work_remotely_production() {
    PILOT_ENVIRONMENT=PRODUCTION zg deployment --task=connect --env=PRODUCTION;
}

# Sometimes the Docker disk image runs out of space (typically every few months).
#   - There isn't any garbage collection of old images in Docker.
#   - Run this command if you see "No space left on device" when trying to run unit tests or deploy
#     - psycopg2.errors.DiskFull: could not write to file "base/6747029/2603_vm": No space left on device
pilot_prune_docker() {
    docker system prune -a;
}

# Every 90 days, we each need to renew our staging and local certificates
pilot_renew_certificates() {
    PILOT_ENVIRONMENT=staging zg renew_certificates;
    PILOT_ENVIRONMENT=local zg renew_certificates;
}

# If you see the error on your sandbox customer, you need to renew the sandbox's qbo oauth.
#   - "Invalid credentials. Update this customer's QuickBooks credentials, then try again."
#
# Run this command, and follow the instructions to give it your username and your sandbox customer's username.
# You will have to copy something from a URL. This is expected.
pilot_renew_quickbooks_oauth() {
    PILOT_ENVIRONMENT=PRODUCTION AWS_PROFILE=pilotprod zg configure_local_environment --stage=setup_quickbooks_oauth;
}

# Sometimes you want to see how your local versions of the repositories are different
# from prod.
#
# Open two browser windows, one zapgram, and one connections, to the github compare URL
# of the current HEAD to whatever is deployed on prod.
pilot_compare_local_to_prod() {
    github_base_url="https://github.com/Zapgram";
    open "${github_base_url}/zapgram/compare/$(curl https://api.pilot.com/health-check 2> /dev/null | jq -r '.version')...$(cd ../zapgram || exit; git rev-parse HEAD)";
    open "${github_base_url}/connections/compare/$(curl https://app.pilot.com/auth/health-check 2> /dev/null | jq -r '.version')...$(cd ../connections || exit; git rev-parse HEAD)";
}


#################### DATABASE ACCESS ################################

# No alias needed! Just use `zg sql`
# The database you connect to will depend on what the PILOT_ENVIRONMENT
# and AWS_PROFILE variablis are set to.



#################### RUN THE WEBSERVER ################################

# Shortcuts: Every time you start your day, you'll want 4 tabs:
#   - pilot_front in one tab
#   - pilot_back in a second tab
#   - zgs in a tab for git
#   - zgs in a tab for tests (front or back)
pilot_front() {
    zgs;
    cd "${PILOT_CONNECTIONS}";
    node server/app.js;
}
pilot_back() {
    zgs;
    PORT_NUMBER=7443 zg api;
}

# If you restart your webserver backend while a zap is running, it may
# get stuck. Use this command to un-stick it!
pilot_reset_sandbox_zaps() {
    zg eng-help reset_running_zaps --customer-username="${USER}sandbox";
}


#################### RUN TESTS ################################

# This is to run tests on the frontend.
#   - The argument should look like "institutions.test.js" or "test/end-to-end/institutions.test.js"
pilot_test_front() {
    cd "${PILOT_CONNECTIONS}";
    DEBUG_TESTS=true npm test "$1";
}

# This is to run tests on the backend.
#   - The argument should look like zg.test.unit.test_paypal_importer
#   - In practice, you should just run it by calling trial
#     yourself: `trial zg.test.unit.test_paypal_importer`
pilot_test_back() {
    cd "${PILOT_ZAPGRAM}";
    trial "$1";
}

# The "fast" option below will run faster and show you errors faster when running lots
# of tests at once, but some errors and print outputs are harder to see/understand, so
# I usually run the slower version above when I'm looking at one test in detail.
#   - The -j 8 makes 8 processes so that it runs faster.
#   - The --rterrors option prints out error tracebacks in real time (as they happen)
#       rather than waiting for the summary at the end of the run
pilot_test_back_fast() {
    cd "${PILOT_ZAPGRAM}";
    trial -j "${PILOT_UNIT_TEST_PARALLELISM:-8}" --rterrors "$1";
}

# Run all of the backend tests through tox, which sets up various
# environmental variables correctly for you.
#   - The `-p auto` says "run all of the tox environments in parallel"
pilot_test_back_full() {
    cd "${PILOT_ZAPGRAM}";
    tox -p auto;
}

# Sometimes Travis is kind of slow; sometimes due to weird service outages or
# race conditions, codecov’s reports don’t make much sense.  You’ve got a fast
# computer right in front of you, you don’t need to wait for all that!
#
# Run this to see coverage locally. You might have to run it twice the first time.
#
# You can read more later at https://coverage.readthedocs.io
pilot_see_coverage() {
    cd "${PILOT_ZAPGRAM}";
    coverage combine; coverage erase;
    tox -p auto &&
    coverage combine &&
    coverage xml &&
    diff-cover coverage.xml --html-report=diff-cover.html &&
    open ./diff-cover.html;
}


#################### RUN LINTERS ################################

# These commands run the linters and type checkers on the
# frontend and backend, respectively.
pilot_lint_front() {
    cd "${PILOT_CONNECTIONS}";
    npm run-script lint:js;
    npm run-script lint:css;
}

# You can learn more about tox by reading tox.ini
# TODO: add more about tox
pilot_lint_back() {
    tox -e mypy -e lint -p auto;
}


#################### UPDATE REQUIREMENTS ##########################

# Update requirements after you or others change them
pilot_update_req_backend() {
    cd "${PILOT_ZAPGRAM}";
    pip install -Ur requirements.txt
    pip install -Ur dev_requirements.txt
}
pilot_update_req_backend_complete() {
    cd "${PILOT_ZAPGRAM}";
    deactivate;
    rm -rf .ve;
    python3.6 -m venv .ve;
    . .ve/bin/activate;
    pip install -Ur requirements.txt;
    pip install -Ur dev_requirements.txt;
    pip install -e .;
}
pilot_update_req_frontend() {
    cd "${PILOT_CONNECTIONS}";
    nvm use;
    npm ci;
}
pilot_update_req_tox() {
    tox -r;
}
pilot_run_migrations() {
    zg deployment --task=run-migrations;
}

############### UUID Gen ###########################

alias -r uuid="uuidgen | tr '[:upper:]' '[:lower:]'  | tr -d '\n' | pbcopy && pbpaste && echo ''"

################ Zulip #############################

zulip() {
    cd "$PILOT_HOME/zulip"
    source .ve/bin/activate
    zulip-term -c zuliprc
}

############### END PILOT DOTFILES #################

# Load our zsh hooks:
if [[ -e ~/.zsh/load-hooks ]]; then
  source ~/.zsh/load-hooks
fi

# Set up git ramdisk workspace:
source ~/.zsh/ramdisk

# viridum + pbcopy
if [[ -e /usr/bin/pbcopy ]]; then
  v() {
    if [[ $# -eq 0 ]]; then
      echo ' ' | tr -d '\n' | /usr/bin/pbcopy
      echo 'cleared'
    else
      echo '' | tr -d '\n' | /usr/bin/pbcopy  # totally clear out the clipboard first
      viridium "$@" | tr -d '\n' | /usr/bin/pbcopy
    fi
  }
else
  v() {
    viridium "$@"
  }
fi

# Helpful functions
alias new-ssh-key="ssh-keygen -t ed25519 -a 100 -C aria@$(hostname)"

# re-enable global rcs after we're done...
setopt GLOBAL_RCS

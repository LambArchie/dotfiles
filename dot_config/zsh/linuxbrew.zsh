# Linuxbrew (Not using 'brew shellenv' as want OS utils preferred)
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"
export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"
export MANPATH="${MANPATH}/home/linuxbrew/.linuxbrew/share/man:"
export INFOPATH="${INFOPATH:-}/home/linuxbrew/.linuxbrew/share/info:"
path+=(
  /home/linuxbrew/.linuxbrew/bin
  /home/linuxbrew/.linuxbrew/sbin
)

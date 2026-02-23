# Not all environment variables are set here.
# Some are set in either .config/environment.d/10-chezmoi.conf (Linux)
# or .config/zsh/before.zsh (macOS)

# CLI Tooling Environment Variables
export CLICOLOR=1
export LSCOLORS="gxBxhxDxfxhxhxhxhxcxcx" # For black background
export EDITOR="/usr/bin/nano"
export VISUAL="/usr/bin/nano"

# Move apps config to XDG_CONFIG_HOME
export AZURE_CONFIG_DIR="$XDG_CONFIG_HOME/azure"
export K9SCONFIG="$XDG_CONFIG_HOME/k9s"

# Move apps data to XDG_DATA_HOME
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite_history"

# Move apps state to XDG_STATE_HOME
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"

# App-specific Environment Variables
export GOPATH="$HOME/Code/go"
export FNM_COREPACK_ENABLED=true
export TALOSCONFIG="$XDG_CONFIG_HOME/talos/config.yml"

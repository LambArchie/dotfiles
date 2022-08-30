#!/bin/bash

### Variables
ASDF_PLUGINS=(
  nodejs
)
ASDF_DATA_DIR=$HOME/.local/share/asdf # This is added to .zshrc to make it permanent

### Install

flatpak install flathub \
  `# Browsers` \
  org.mozilla.firefox \
  org.freedesktop.Platform.ffmpeg-full \
  com.microsoft.Edge \
  `# Essentials` \
  com.bitwarden.desktop \
  com.spotify.Client \
  com.microsoft.Teams \
  us.zoom.Zoom \
  `# Gaming` \
  com.discordapp.Discord \
  org.polymc.PolyMC \
  com.github._0negal.Viper `# Titanfall 2 Northstar Updater` \
  net.davidotek.pupgui2 `# ProtonUp-QT` \
  `# Programming` \
  com.getpostman.Postman \
  com.jgraph.drawio.desktop \
  io.dbeaver.DBeaverCommunity \
  `# Utilities` \
  com.github.tchx84.Flatseal \
  com.github.wwmm.easyeffects \
  org.openrgb.OpenRGB \
  com.usebottles.bottles \
  in.srev.guiscrcpy \
  io.github.celluloid_player.Celluloid \
  org.pipewire.Helvum

# Fedora packaged firefox gets slow updates
sudo flatpak override --socket=wayland --env=MOZ_ENABLE_WAYLAND=1 org.mozilla.firefox
sudo dnf remove -y firefox

# Add Package Repos
sudo sh -c 'echo -e "[google-cloud-cli]\nname=Google Cloud CLI\nbaseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el8-x86_64\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=0\ngpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg\n       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" > /etc/yum.repos.d/google-cloud-sdk.repo'
# Fedora specific repo only has dotnet
sudo dnf config-manager --add-repo https://packages.microsoft.com/config/centos/8/prod.repo
sudo mv /etc/yum.repos.d/prod.repo /etc/yum.repos.d/microsoft.repo
# Not using Flatpak VSCode due to terminal restrictions
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

dnf check-update

sudo dnf install -y \
  `# GUI Applications` \
  code \
  darkman \
  google-chrome-stable \
  libreoffice \
  `# CLI Tools` \
  android-tools \
  docker-compose \
  fzf \
  google-cloud-cli \
  google-cloud-cli-gke-gcloud-auth-plugin \
  htop \
  jq \
  neovim \
  podman podman-docker \
  powershell \
  python3-pip \
  ripgrep \
  tokei \
  screen \
  zsh \
  `# Fonts` \
  mscore-fonts-all \
  adobe-source-serif-pro-fonts.noarch \
  adobe-source-code-pro-fonts.noarch \
  adobe-source-sans-pro-fonts.noarch \
  cascadia-fonts-all.noarch \
  fira-code-fonts.noarch \
  google-roboto-fonts.noarch \
  google-rubik-fonts.noarch \
  jetbrains-mono-fonts.noarch \
  julietaula-montserrat-fonts.noarch \
  lato-fonts.noarch \
  mozilla-fira-mono-fonts.noarch \
  mozilla-fira-sans-fonts.noarch \
  open-sans-fonts.noarch \
  rsms-inter-fonts.noarch

# Install Homebrew/Linuxbrew Package Manager
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Homebrew/Linuxbrew Packages
brew install \
  asdf \
  argocd \
  awscli \
  azure-cli \
  caddy \
  checkov \
  chezmoi \
  gh \
  norwoodj/tap/helm-docs \
  helm-docs \
  httpie \
  krew \
  kubernetes-cli \
  romkatv/powerlevel10k/powerlevel10k \
  pipx \
  python@3.10 \
  pulumi \
  tldr \
  hashicorp/tap/vault \
  yq

# ASDF Plugin Install
for plugin in "${ASDF_PLUGINS[@]}"; do
  asdf plugin add "$plugin"
  asdf install "$plugin" latest
  asdf global "$plugin" latest
done

# Spicetify (Spotify Mod)
curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh
mv ~/.spicetify ~/.local/share/spicetify
sed -i "s~prefs_path              = ~prefs_path              = $HOME/.var/app/com.spotify.Client/config/spotify/prefs~g" ~/.config/spicetify/config-xpui.ini
~/.local/share/spicetify/spicetify backup
~/.local/share/spicetify/spicetify config extensions "fullAppDisplay.js|keyboardShortcut.js|popupLyrics.js|shuffle+.js"
wget -P "~/.config/spicetify/Extensions/" "https://raw.githubusercontent.com/theRealPadster/spicetify-hide-podcasts/main/hidePodcasts.js"
wget -P "~/.config/spicetify/Extensions/" "https://raw.githubusercontent.com/3raxton/spicetify-custom-apps-and-extensions/main/v2/show-queue-duration/showQueueDuration.js"
~/.local/share/spicetify/spicetify config extensions "hidePodcasts.js"
~/.local/share/spicetify/spicetify apply

# Nerd Fonts
mkdir ~/Code
git clone --depth 1 --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts ~/Code/nerd-fonts
(cd ~/Code/nerd-fonts && \
git sparse-checkout add patched-fonts/CascadiaCode && ./install.sh CascadiaCode && \
git sparse-checkout add patched-fonts/Meslo && ./install.sh Meslo && \
git sparse-checkout add patched-fonts/Ubuntu && ./install.sh Ubuntu && \
git sparse-checkout add patched-fonts/UbuntuMono && ./install.sh UbuntuMono && \
)

### Configuration

# Change Default Shell
sudo chsh -s $(which zsh) $USER

# Chezmoi Config
chezmoi init --apply LambArchie

# Darkman Configuration (Automatic DarkMode Toggle)
mkdir -p ~/.local/share/{dark,light}-mode.d
wget "https://gitlab.com/WhyNotHugo/darkman/-/raw/main/examples/dark-mode.d/kde-global-theme.sh" -O ~/.local/share/dark-mode.d/kde-global-theme.sh
chmod +x ~/.local/share/dark-mode.d/kde-global-theme.sh
echo -e "\nkwriteconfig5 --file ~/.config/kwinrc --group TabBox --key LayoutName thumbnail_grid" | tee -a ~/.local/share/dark-mode.d/kde-global-theme.sh
cp ~/.local/share/dark-mode.d/kde-global-theme.sh ~/.local/share/light-mode.d/kde-global-theme.sh
sed -i 's/breezedark/breezetwilight/g' ~/.local/share/light-mode.d/kde-global-theme.sh
systemctl --user enable --now darkman.service

# Fix Discord Rich Presence
mkdir -p ~/.config/user-tmpfiles.d
echo 'L %t/discord-ipc-0 - - - - app/com.discordapp.Discord/discord-ipc-0' > ~/.config/user-tmpfiles.d/discord-rpc.conf
systemctl --user enable --now systemd-tmpfiles-setup.service

# Setting Configuration
# Misc Settings
kwriteconfig5 --file ~/.config/kwinrc --group "TabBox" --key "LayoutName" "thumbnail_grid"
kwriteconfig5 --file ~/.config/kwinrc --group "NightColor" --key "Active" "true"
kwriteconfig5 --file ~/.config/PlasmaDiscoverUpdates --group "Global" --key "UseUnattendedUpdates" "true"
kwriteconfig5 --file ~/.config/konsolerc --group "<default>" --key "MenuBar" "Disabled"
# Default Applications
kwriteconfig5 --file ~/.config/mimeapps.list --group "Added Associations" --key "application/json" "code.desktop;org.kde.kwrite.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group "Default Applications" --key "application/json" "code.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group "Added Associations" --key "application/x-wine-extension-ini" "code.desktop;org.kde.kwrite.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group "Default Applications" --key "application/x-wine-extension-ini" "code.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group "Default Applications" --key "x-scheme-handler/http" "org.mozilla.firefox.desktop;"
kwriteconfig5 --file ~/.config/mimeapps.list --group "Default Applications" --key "x-scheme-handler/https" "org.mozilla.firefox.desktop;"
kwriteconfig5 --file ~/.config/kdeglobals --group "General" --key "BrowserApplication" "org.mozilla.firefox.desktop"
# KeyBinds
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group "kmix" --key "mic_mute" "Meta+Volume Mute	Tools	Microphone Mute,Microphone Mute	Meta+Volume Mute,Mute Microphone" # Add F13 to Mic Mute. KeyVal intentionally includes Tabs Character
kwriteconfig5 --file ~/.config/kglobalshortcutsrc --group "systemsettings.desktop" --key "_launch" "none,Tools,System Settings" # Remove Default F13 keybind (Tools=F13)
# Lockscreen (SDDM)
sudo kwriteconfig5 --file /etc/sddm.conf.d/custom.conf --group "General" --key "Numlock" "on"
sudo chmod +r /etc/sddm.conf.d/custom.conf
# Mouse Settings
kwriteconfig5 --file ~/.config/kcminputrc --group "Libinput" --group "1133" --group "49295" --group "Logitech G403 HERO Gaming Mouse" --key "PointerAcceleration" "0.200" # Not Mouse Acceleration
kwriteconfig5 --file ~/.config/kcminputrc --group "Libinput" --group "1133" --group "49295" --group "Logitech G403 HERO Gaming Mouse" --key "PointerAccelerationProfile" "1"
kwriteconfig5 --file ~/.config/kcminputrc --group "Libinput" --group "1133" --group "49295" --group "Logitech G403 HERO Gaming Mouse" --key "ScrollFactor" "1.75"
# Search Settings
kwriteconfig5 --file ~/.config/krunnerrc --group "Plugins" --key "plasma-runner-browserhistoryEnabled" "false"
kwriteconfig5 --file ~/.config/krunnerrc --group "Plugins" --key "plasma-runner-browsertabsEnabled" "false"
kwriteconfig5 --file ~/.config/krunnerrc --group "Plugins" --key "webshortcutsEnabled" "false"
# Telemetry
kwriteconfig5 --file ~/.config/PlasmaUserFeedback --group "Global" --key "FeedbackLevel" "16" # Set to Basic System Information instead of Disabled
# Konsole
kwriteconfig5 --file ~/.config/konsolerc --group "Desktop Entry" --key "DefaultProfile" "Personal.profile"

### Manual Intervention Required

# Setup XBox Drivers
nobara-controller-config

# Login to GitHub & Generate SSH Key
echo "Generate new SSH key, ensuring it has a passphrase and suitable name. Will need to enter the passphrase again after completing the login into GitHub"
gh config set git_protocol ssh
gh auth login -p ssh -h github.com

# Store SSH Passphrase in KDE Wallet
SSH_ASKPASS="/usr/bin/ksshaskpass"
SSH_ASKPASS_REQUIRE="prefer"
ssh-add ~/.ssh/id_ed25519
mkdir -p ~/.config/autostart
mkdir -p ~/.config/environment.d
cat <<EOF >~/.config/autostart/ssh-add.desktop
[Desktop Entry]
Exec=ssh-add -q ~/.ssh/id_ed25519
Name=ssh-add
Type=Application
EOF
cat <<EOF >~/.config/environment.d/ssh_askpass.conf
SSH_ASKPASS="/usr/bin/ksshaskpass"
SSH_ASKPASS_REQUIRE="prefer"
EOF

#!/bin/bash

### Variables

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
  org.gnome.Evince \
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
  `# System Tools` \
  kdenetwork-filesharing \
  snapper \
  python3-dnf-plugin-snapper \
  wine-mono \
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
  pwgen \
  python3-pip \
  rclone \
  ripgrep \
  screen \
  tokei \
  zsh \
  `# Fonts` \
  mscore-fonts-all \
  adobe-source-serif-pro-fonts.noarch \
  adobe-source-code-pro-fonts.noarch \
  adobe-source-sans-pro-fonts.noarch \
  cascadia-fonts-all.noarch \
  fira-code-fonts.noarch \
  google-carlito-fonts.noarch \
  google-roboto-fonts.noarch \
  google-rubik-fonts.noarch \
  ht-caladea-fonts.noarch \
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
  argocd \
  awscli \
  azure-cli \
  caddy \
  checkov \
  chezmoi \
  gh \
  helm \
  norwoodj/tap/helm-docs \
  httpie \
  krew \
  kubernetes-cli \
  kustomize \
  romkatv/powerlevel10k/powerlevel10k \
  pipx \
  python@3.10 \
  pulumi \
  tldr \
  hashicorp/tap/vault \
  yq

# nvm
export NVM_DIR="$HOME/.config/nvm"
mkdir -p $NVM_DIR
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

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
mkdir -p ~/Code
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

# Allow user samba
sudo mkdir /var/lib/samba/usershares
sudo groupadd -r sambashare
sudo chown root:sambashare /var/lib/samba/usershares
sudo chmod 1770 /var/lib/samba/usershares
sudo gpasswd sambashare -a $USER
sudo setsebool -P samba_enable_home_dirs 1

# Snapshot Setup
sudo snapper -c root create-config /

# Fix Discord Rich Presence
mkdir -p ~/.config/user-tmpfiles.d
echo 'L %t/discord-ipc-0 - - - - app/com.discordapp.Discord/discord-ipc-0' > ~/.config/user-tmpfiles.d/discord-rpc.conf
systemctl --user enable --now systemd-tmpfiles-setup.service

### Manual Intervention Required

# Setup XBox Drivers
nobara-controller-config

# Login to GitHub & Generate SSH Key
echo "Generate new SSH key, ensuring it has a passphrase and suitable name. Will need to enter the passphrase again after completing the login into GitHub"
gh config set git_protocol ssh
gh auth login -p ssh -h github.com

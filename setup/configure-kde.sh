#!/bin/bash

### KDE Configuration

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

# Darkman Configuration (Automatic DarkMode Toggle)
mkdir -p ~/.local/share/{dark,light}-mode.d
wget "https://gitlab.com/WhyNotHugo/darkman/-/raw/main/examples/dark-mode.d/kde-global-theme.sh" -O ~/.local/share/dark-mode.d/kde-global-theme.sh
chmod +x ~/.local/share/dark-mode.d/kde-global-theme.sh
echo -e "\nkwriteconfig5 --file ~/.config/kwinrc --group TabBox --key LayoutName thumbnail_grid" | tee -a ~/.local/share/dark-mode.d/kde-global-theme.sh
cp ~/.local/share/dark-mode.d/kde-global-theme.sh ~/.local/share/light-mode.d/kde-global-theme.sh
sed -i 's/breezedark/breezetwilight/g' ~/.local/share/light-mode.d/kde-global-theme.sh
systemctl --user enable --now darkman.service

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

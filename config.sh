#!/bin/bash

print_line() {
	printf "%$(tput cols)s\n"|tr ' ' '-'
}

print_title() {
	clear
	print_line
	echo -e "# ${Bold}$1${Reset}"
	print_line
	echo ""
}

 #配置汉化
configure_Chinese(){
	print_title "configure_Chinese"
        sudo chmod 777 /etc/pacman.d/mirrorlist
        sudo sh -c 'echo -e "[archlinuxcn]\nServer = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf'
        sudo pacman -Syy
        sudo pacman -S --noconfirm archlinuxcn-keyring -y
        sudo sh -c 'sed -i 's/\# \[multilib]/\[multilib]/g' /etc/pacman.conf'
        sudo sh -c 'sed -i 's/\# \Include = /etc/pacman.d/mirrorlist/\Include = /etc/pacman.d/mirrorlist/g' /etc/pacman.conf'
        sudo pacman -Syu --noconfirm
        #echo "LANG=zh_CN.UTF-8" >> /etc/locale.conf
        mkdir ~/.xprofile
	sudo sh -c 'echo "export LANG=zh_CN.UTF-8\nexport LANGUAGE=zh_CN:en_US" >> ~/.xprofile'
 }
 
  #安装基本软件
 add_baseapplication(){
       print_title "add_baseapplication"
       sudo pacman -S --noconfirm pavucontrol alsa-utils pulseaudio pulseaudio-alsa -y
       sudo pacman -S --noconfirm nano gvfs ntfs-3g gvfs-mtp p7zip file-roller unrar netease-cloud-music wps-office ttf-wps-fonts leafpad -y
       sudo pacman -S --noconfirm vlc ark -y
       sudo pacman -S --noconfirm firefox firefox-i18n-zh-cn -y
       sudo pacman -S --noconfirm git wget yaourt yay fakeroot -y
       sudo systemctl start alsa-state.service
       sudo systemctl enable alsa-state.service
 }
 
   #安装中文输入法
  add_ChineseInput(){
       print_title "add_ChineseInput"
       sudo pacman -S --noconfirm fcitx fcitx-im fcitx-configtool -y
       sudo sh -c 'echo -e "export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS=“@im=fcitx”" >> ~/.xprofile'
       sudo sh -c 'echo -e "export GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS=“@im=fcitx”" >> ~/.bashrc'
  } 
   
      
   #安装系统图标字体主题包（重启后把shell,gtk.图标等改成这些就好了）
  add_theme(){
      print_title "add_theme"
      yaourt -S --noconfirm gtk-theme-arc-git numix-circle-icon-theme-git
      git clone https://github.com/powerline/fonts.git --depth=1
      mv fonts source-code-pro-medium-italic
      sudo mv source-code-pro-medium-italic /usr/share/fonts/
      cd /usr/share/fonts/source-code-pro-medium-italic
      sudo bash install.sh
      cd
   } 
   #安装zsh
  add_zsh(){
      print_title "add_zsh"
      sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
      mkdir ~/.oh-my-zsh/custom/plugins/
      cd ~/.oh-my-zsh/custom/plugins/
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
      git clone https://github.com/zsh-users/zsh-autosuggestions
      cd
      zsh
# nano ~/.zshrc,将主题改成：ZSH_THEME="agnoster" （zsh-syntax-highlighting必须放最下面。这个不会写，只能这样子备注了，重启后照着这个改就好了）
#加入插件，即在plugins=(git)加入插件名字，改成
#     plugins=(
#       git
#       zsh-autosuggestions
#       zsh-syntax-highlighting               
#      )                          

      clear
      print_title "config has been.please reboot ."
  } 
  
  configure_Chinese
  add_baseapplication
  add_ChineseInput
  add_theme
  add_zsh

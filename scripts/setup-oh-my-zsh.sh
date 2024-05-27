#!/usr/bin/env sh

OH_MY_ZSH="$HOME/.oh-my-zsh/"
OH_MY_ZSH_PLUGINS="$OH_MY_ZSH/plugins/"

if [ ! -d "$OH_MY_ZSH" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [ ! -d "$OH_MY_ZSH_PLUGINS"/zsh-autosuggestions ]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$OH_MY_ZSH_PLUGINS"/zsh-autosuggestions || true
fi

if [ ! -d "$OH_MY_ZSH_PLUGINS"/zsh-completions ]; then
  rm -f ~/.zcompdump
  git clone --depth 1 https://github.com/zsh-users/zsh-completions.git "$OH_MY_ZSH_PLUGINS"/zsh-completions || true
fi

if [ ! -d "$OH_MY_ZSH_PLUGINS"/zsh-syntax-highlighting ]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$OH_MY_ZSH_PLUGINS"/zsh-syntax-highlighting || true
fi

if [ ! -d "$OH_MY_ZSH"/themes/powerlevel10k ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

FROM pytorch/pytorch:2.6.0-cuda12.6-cudnn9-devel

ARG USERNAME=user
ARG GROUPNAME=user

ARG UID=1000
ARG GID=1000

#Group and USER

RUN groupadd -g $GID $GROUPNAME \
  && useradd -m -s /bin/bash -u $UID -g $GID $USERNAME \
  && apt-get update && apt-get install -y sudo curl \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME

ARG TZ
ENV TZ="$TZ"

USER root

# Locale Configuration

RUN apt-get update && apt-get install -y locales \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install basic development tools (ensure curl is here for Oh My Zsh installer)

RUN apt-get update && apt-get install -y less \
  git \
  wget \
  curl \
  procps \
  # sudo is already installed
  fzf \
  zsh \
  man-db \
  unzip \
  gnupg2 \
  gh \
  iptables \
  ipset \
  iproute2 \
  dnsutils \
  aggregate \
  jq \
  tmux \
  gh \
  connect-proxy \
  ffmpeg \
  rsync

# Install git-delta
RUN ARCH=$(dpkg --print-architecture) && \
  wget "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_${ARCH}.deb" && \
  dpkg -i "git-delta_0.18.2_${ARCH}.deb" && \
  rm "git-delta_0.18.2_${ARCH}.deb"

# Set the default shell for the user to zsh

RUN usermod --shell /bin/zsh $USERNAME

# Switch to the user

USER $USERNAME
WORKDIR /home/$USERNAME

# Install Oh My Zsh (non-interactive)

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Define ZSH_CUSTOM for clarity

ENV ZSH_CUSTOM=/home/$USERNAME/.oh-my-zsh/custom

# Install Oh My Zsh plugins and Powerlevel10k theme

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k

# Copy the pre-configured .p10k.zsh file BEFORE editing .zshrc

COPY --chown=$USERNAME:$GROUPNAME .p10k.zsh /home/$USERNAME/.p10k.zsh

# Configure .zshrc

RUN ZSHRC_FILE=/home/$USERNAME/.zshrc && \
  # 1. Set the theme to Powerlevel10k
  sed -i 's|^ZSH_THEME=".*"$|ZSH_THEME="powerlevel10k/powerlevel10k"|' $ZSHRC_FILE && \
  # 2. Set plugins (fzf is configured manually below)
  sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' $ZSHRC_FILE

# Manually add fzf configuration
RUN echo '\n# FZF configuration (manual setup)' >> /home/$USERNAME/.zshrc && \
  echo '[ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh' >> /home/$USERNAME/.zshrc && \
  echo '[ -f /usr/share/fzf/shell/completion.zsh ] && source /usr/share/fzf/shell/completion.zsh' >> /home/$USERNAME/.zshrc



# --- ★★★ここからが今回の重要な追加修正です★★★ ---

# Add settings to the end of .zshrc to ensure they are loaded

RUN echo '\n# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.' >> /home/$USERNAME/.zshrc && \
  echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> /home/$USERNAME/.zshrc && \
  echo '\n# Disable Powerlevel10k configuration wizard' >> /home/$USERNAME/.zshrc && \
  echo 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' >> /home/$USERNAME/.zshrc



# Zsh History configuration (this can be placed before or after the new block)

RUN echo '\n# Custom History Configuration' >> /home/$USERNAME/.zshrc && \
  echo 'export HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history' >> /home/$USERNAME/.zshrc && \
  echo 'export HISTSIZE=10000' >> /home/$USERNAME/.zshrc && \
  echo 'export SAVEHIST=10000' >> /home/$USERNAME/.zshrc && \
  echo "setopt APPEND_HISTORY" >> /home/$USERNAME/.zshrc && \
  echo "setopt EXTENDED_HISTORY" >> /home/$USERNAME/.zshrc && \
  echo "setopt HIST_IGNORE_ALL_DUPS" >> /home/$USERNAME/.zshrc && \
  echo "setopt HIST_REDUCE_BLANKS" >> /home/$USERNAME/.zshrc && \
  echo "setopt INC_APPEND_HISTORY" >> /home/$USERNAME/.zshrc && \
  echo "setopt SHARE_HISTORY" >> /home/$USERNAME/.zshrc && \
  touch /home/$USERNAME/.zsh_history
#!/bin/bash

# GitHub SSH設定スクリプト
# コンテナ作成後に自動実行される

echo "Setting up GitHub SSH configuration..."

# SSHディレクトリが存在しない場合は作成
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# SSH設定ファイルを作成/更新
cat > ~/.ssh/config << 'EOF'
Host github.com
  HostName ssh.github.com
  User git
  Port 443
  ProxyCommand connect -H http://proxy11.omu.ac.jp:8080 %h %p
  StrictHostKeyChecking accept-new
EOF

chmod 600 ~/.ssh/config

# # SSHキーが存在しない場合は生成
# if [ ! -f ~/.ssh/id_ed25519 ]; then
#     echo "Generating new SSH key..."
#     ssh-keygen -t ed25519 -C "user@devcontainer" -f ~/.ssh/id_ed25519 -N ""
#     echo ""
#     echo "=========================================="
#     echo "新しいSSHキーが生成されました。"
#     echo "以下の公開鍵をGitHubに追加してください："
#     echo "=========================================="
#     cat ~/.ssh/id_ed25519.pub
#     echo "=========================================="
#     echo ""
# else
#     echo "SSH key already exists."
# fi

# 既存のワークスペースのパーミッション修正
sudo chown -R user:user ${containerWorkspaceFolder}

# ワークスペースの所有者を変更（必要に応じて）
# sudo chown -R ect01:ect .
# sudo chown -R user:user .

echo "GitHub SSH setup completed!"

rsync -a --delete .devcontainer/.claude/ ~/.claude/

pip install ipykernel

# ./.devcontainer/sync_claude.sh
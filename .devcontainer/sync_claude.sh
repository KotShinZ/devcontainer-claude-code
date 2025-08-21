#  This script synchronizes the .claude directory with the user's home directory.

rsync -a --delete .devcontainer/.claude/ ~/.claude/
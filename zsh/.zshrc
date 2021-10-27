# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra,personal}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
  done;
  unset file;

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/danielryan/Development/idearoom/stanley/carportview/server/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/danielryan/Development/idearoom/stanley/carportview/server/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/danielryan/Development/idearoom/stanley/carportview/server/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/danielryan/Development/idearoom/stanley/carportview/server/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/danielryan/Development/idearoom/stanley/api/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/danielryan/Development/idearoom/stanley/api/node_modules/tabtab/.completions/slss.zsh
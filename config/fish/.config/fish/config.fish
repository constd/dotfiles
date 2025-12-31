if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
end


fzf --fish | source

starship init fish | source
uv generate-shell-completion fish | source
uvx --generate-shell-completion fish | source

set -gx LIBTORCH /Users/const/libs/libtorch/2.9.0
set -gx DYLD_LIBRARY_PATH /Users/const/libs/2.9.0/lib:$DYLD_LIBRARY_PATH
# set -gx LIBTORCH_USE_PYTORCH 1
# set -gx LIBTORCH_BYPASS_VERSION_CHECK 1

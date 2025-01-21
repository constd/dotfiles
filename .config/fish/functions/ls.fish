function ls -d 'exa instead of ls'
  if type --quiet exa
    exa --group-directories-first --git --icons $argv
  else
    command ls --color=auto $argv
  end
end

function ll -d 'alias ls -l'
  ls -l $argv
end

function la -d 'alias ls -la'
  ls -la $argv
end

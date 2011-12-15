#!/bin/sh
# rake bash completion script

__complete_taskr(){
  echo "$0" >> /tmp/completion.log
  echo "$1" >> /tmp/completion.log
  echo "$2" >> /tmp/completion.log
  echo "$3" >> /tmp/completion.log
  /home/minhajuddin/.scripts/t -i "$2"
}

#complete_cr_command() {
  #ls ~/repos/ | grep "^$2"
#}

complete -C __complete_taskr -o nospace t

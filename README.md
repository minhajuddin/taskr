#Taskr
Simple command line utility to manage your tasks

##Todo
- should setup a standalone installer like https://github.com/defunkt/hub/blob/master/Rakefile, https://github.com/defunkt/hub/blob/master/lib/hub/standalone.rb

###Screenshot
![Screenshot](http://i.imgur.com/EtaEG.png)

##Command line help
    $ t -h
    Usage: taskr [options]
        -a, --add task description       Add task to the list
        -l, --list [NUM]                 List all the tasks
        -L, --list-all                   List all the tasks
        -d, --delete id1,id2,..          Delete tasks(s)
        -s, --search REGEX               Search all the tasks
        -e, --edit                       Open the tasks file in vi
        -t id1,id2,.. :tag1 :tag2 ..,    Tag task(s)
            --tag
        -u id1,id2,.. :tag1 :tag2 ..,    Untag task(s)
            --untag
        -p, --postpone id1,id2,..        Postpone task(s) to tomorrow
        -x, --xmobar                     Text to be shown in xmobar
        -v, --version                    Display version of taskr
        -h, --help                       Display this screen


#Taskr
*Simple command line utility to manage your tasks*

##Usage
Taskr allows you to embed all the information about the task *in* the task.

 - Any word in a task which begins with `:` is considered a *tag*.
 - The tags `:weekend, :today, :tomorrow, :tray` have a special meaning.  
   Tasks tagged:
   - `:today` are highlighted in a different color in the listing and get a higher priority.
   - `:tomorrow` are hidden from the default listing. You can list all tasks using the `-L` switch.
   - `:weekend` are visible in the default listing only on weekends. You can list all tasks using the `-L` switch.
   - `:tray` are shown on the top and have a different background color, they have the highest priority. You can put tasks into your tray when you are working on them, or when you want to tackle a bunch of tasks.
- Tasks which have a bunch of pluses(`+`) get their priority increased by the number of `+`s. On the other hand tasks with minuses(`-`)s in them have lower priorities

Deleted tasks are copied into the `~/.taskr/tasks.taskr.done` file with a timestamp, we can probably add something in the future which allows us to check the time spent on tasks and give more insight into the kind of tasks we work on.

##Screenshot
![Screenshot](http://i.imgur.com/EtaEG.png)

##File storage
Taskr stores the tasks in a plain text file in the following format:


````text
20110913123500 setting up dotfiles :weekend :tray ++
20110928154156 use slotter/dnotify as an activator for alarms and a notifier/triggerer of events and processes from dnotify :weekend :tray +
20111122054143 add posts about redirection rewrites on different servers at redirectapp :weekend +++++
20111115130124 google adwords setup :weekend :20111211 ++
20110929083045 spool for kindle :weekend +
20111010161947 setup to take screenshots of stuff on IE7 8 9 chrome firefox :weekend +
20110915105500 chrome extension with persistent alarm :weekend 
````

As you can see it's just a text file with a timestamp for every task.

##Install
**You need ruby - 1.8.7 or 1.9.2 to use taskr.**
Installing taskr is pretty straightforward, run the following commands

####With git
````bash
git clone git://github.com/minhajuddin/taskr.git ~/.taskr-code
ln -s ~/.taskr-code/bin/taskr ~/bin/t
cd ~/.taskr-code/ && rake setup
````
####Without git
````bash
curl -Ls https://github.com/minhajuddin/taskr/tarball/master > /tmp/taskr.tar.gz
cd /tmp/
tar -xvf taskr.tar.gz
mv $(find .  -maxdepth 1 -type d | grep minhajuddin*) ~/.taskr-code
ln -s ~/.taskr-code/bin/taskr ~/bin/t
cd ~/.taskr-code/ && rake setup
````


##Command line help
````bash
$ bin/taskr -h
Usage: taskr [options]
  Two of the most used options are -l and -a,
  and you can use these options without the switches.

  e.g.
    $ taskr awesome task here hurray for no switches
      #adds the task to the list and is equivalent to taskr -a awes..
    $ taskr
      #lists all the tasks and is equivalent to 'taskr -l'

Options:
    -a, --add task description                Add task to the list
    -l, --list [NUM]                          List all the tasks
    -L, --list-all                            List all the tasks
    -d, --delete id1,id2,..                   Delete tasks(s)
    -s, --search REGEX                        Search all the tasks
    -e, --edit                                Open the tasks file in vi
    -t, --tag id1,id2,.. :tag1 :tag2 ..,      Tag task(s)
    -u, --untag id1,id2,.. :tag1 :tag2 ..,    Untag task(s)
    -p, --postpone id1,id2,..                 Postpone task(s) to tomorrow
    -x, --xmobar                              Text to be shown in xmobar
    -v, --version                             Display version of taskr
    -h, --help                                Display this screen

````

##Vim files
There is a small vim syntax file the vim directory, just copy it to your `~/.vim/syntax` folder and put the line below in your `~/.vimrc` to get some basic syntax highlighting when you edit the tasks raw file.

````vim
au BufNewFile,BufRead *.taskr  setf taskr
````
##FAQ
 1. **Why is it not packaged as a gem?**  
 To make it run faster. More info here: https://gist.github.com/284823
 2. **Seriously, is 0.5s is gonna make a difference?**  
 *Yes*, This is not just from *my* experience. The perceived slowness of many apps has made me avoid them. [Jeff Atwood post on it is a good read](http://www.codinghorror.com/blog/2011/06/performance-is-a-feature.html)  

    > [Google found that] the page with 10 results took 0.4 seconds to generate. The page with 30 results took 0.9 seconds. Half a second delay caused a 20% drop in traffic. Half a second delay killed user satisfaction.
    > In A/B tests, [Amazon] tried delaying the page in increments of 100 milliseconds and found that even very small delays would result in substantial and costly drops in revenue.

 3. **How fast is it?**  
 Very fast

    ````bash
    $ time t
    real    0m0.039s
    user    0m0.040s
    sys     0m0.000s
    ````
 4. **How is it better than Task Warrior or X?**  
   It is more hackable. To efficiently use it, you don't have to learn hundreds of switches.
   It's similar to markdown, in that, it allows you to attach info to your task in a way which makes sense.
   Read the usage section.
 5. **Give me a real reason.**  
    No one loves a task manager built by others, because everyone has something which they do differently. I created this to suit my workflow and needs. And because it's built in ruby and aims to be configurable, I hope it is easier to personalize.

##Todo
 - allow listing of tasks from other *sources*
 - add tab completion
 - allow users to configure priority rules
 - allow users to configure :tag rules
 - allow users to configure :tag transforms

##Author
  Created by Khaja Minhajuddin: minhajuddin (at) cosmicvent (dot) com

##Credits
 - Uses colorize `String` extension from https://github.com/fazibear/colorize
 - Timeago `Time` extension from: http://stackoverflow.com/a/195894/24105

##Alternatives
  There are a few other alternatives if you don't like this:
 - [Task warrior, written in C++](http://taskwarrior.org/projects/show/taskwarrior)
 - [dooby](https://github.com/rafmagana/dooby)


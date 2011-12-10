module Taskr
  class Runner
    attr_reader :args

    def initialize(*args)
      @args = Args.new(args)
      Commands.run(@args)
    end

    # Shortcut
    def self.execute(*args)
      new(*args).execute
    end

    # A string representation of the command that would run.
    def command
      if args.skip?
        ''
      else
        commands.join('; ')
      end
    end

    # An array of all commands as strings.
    def commands
      args.commands.map do |cmd|
        if cmd.respond_to?(:join)
          # a simplified `Shellwords.join` but it's OK since this is only used to inspect
          cmd.map { |arg| arg = arg.to_s; (arg.index(' ') || arg.empty?) ? "'#{arg}'" : arg }.join(' ')
        else
          cmd.to_s
        end
      end
    end

    # Runs the target git command with an optional callback. Replaces
    # the current process.
    #
    # If `args` is empty, this will skip calling the git command. This
    # allows commands to print an error message and cancel their own
    # execution if they don't make sense.
    def execute
      if args.noop?
        puts commands
      elsif not args.skip?
        if args.chained?
          execute_command_chain
        else
          exec(*args.to_exec)
        end
      end
    end

    # Runs multiple commands in succession; exits at first failure.
    def execute_command_chain
      commands = args.commands
      commands.each_with_index do |cmd, i|
        if cmd.respond_to?(:call) then cmd.call
        elsif i == commands.length - 1
          # last command in chain
          exec(*cmd)
        else
          exit($?.exitstatus) unless system(*cmd)
        end
      end
    end
  end
end


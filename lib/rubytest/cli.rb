module Test

  # Command line interface.
  class Runner

    # Test runner command line interface.
    #
    def self.cli(*argv)
      runner = Runner.new

      Test::Config.load

      cli_options(runner, argv)

      Test::Config.load_path_setup  #unless runner.autopath == false

      begin
        success = runner.run
        exit -1 unless success
      rescue => error
        raise error if $DEBUG
        $stderr.puts('ERROR: ' + error.to_s)
      end
    end

    #
    def self.cli_options(runner, argv)
      require 'optparse'

      config = Test.config.dup
      config_loaded = false

      common  = config.delete('common')
      default = config.delete('default')

      common.call(runner) if common

      OptionParser.new do |opt|
        opt.banner = "Usage: #{$0} [options] [files ...]"

        unless config.empty?
          opt.separator "PRESET OPTIONS:"
          config.each do |name, block|
            opt.on("--#{name}") do
              block.call(runner)
            end
          end
        end

        opt.separator "CONFIG OPTIONS:"

        opt.on '-f', '--format NAME', 'report format' do |name|
          runner.format = name
        end
        opt.on '-y', '--tapy', 'shortcut for -f tapy' do
          runner.format = 'tapy'
        end
        opt.on '-j', '--tapj', 'shortcut for -f tapj' do
          runner.format = 'tapj'
        end

        opt.on '-t', '--tag TAG', 'select tests by tag' do |tag|
          runner.tags << tag
        end
        opt.on '-u', '--unit TAG', 'select tests by software unit' do |unit|
          runner.units << unit
        end
        opt.on '-m', '--match TEXT', 'select tests by description' do |text|
          runner.match << text 
        end

        opt.on '-I', '--loadpath PATH',  'add to $LOAD_PATH' do |paths|
          paths.split(/[:;]/).reverse_each do |path|
            $LOAD_PATH.unshift path
          end
        end
        opt.on '-r', '--require FILE', 'require file' do |file|
          require file
        end
        opt.on '-v' , '--verbose', 'provide extra detailed report' do
          runner.verbose = true
        end
        #opt.on('--log DIRECTORY', 'log directory'){ |dir|
        #  options[:log] = dir
        #}
        opt.on_tail("--[no-]ansi" , 'turn on/off ANSI colors'){ |v| $ansi = v }
        opt.on_tail("--debug" , 'turn on debugging mode'){ $DEBUG = true }
        #opt.on_tail("--about" , 'display information about lemon'){
        #  puts "Ruby Test v#{VERSION}"
        #  puts "#{COPYRIGHT}"
        #  exit
        #}
        opt.on_tail('-h', '--help', 'display this help message'){
          puts opt
          exit
        }
      end.parse!(argv)

      default.call(runner) if default && !config_loaded

      runner.files.replace(argv) unless argv.empty?
    end

  end

end
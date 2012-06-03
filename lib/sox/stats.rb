module Sox
  class Stats

    attr_reader :command
    attr_accessor :use_cache

    def initialize(file = nil, options = {})
      options.each { |k,v| send "#{k}=", v }
      @command = Sox::Command.new.tap do |command|
        command.effect "stats"
        command.input file if file
      end
    end

    delegate :input, :to => :command

    def raw_output
      command.run!.run_output
    end

    def raw_values
      if raw_output.chomp == "sox WARN stats: no audio"
        raise "No audio found by sox"
      else
        raw_output.scan(/^(\w+( \w+)*) +([\w.-]+)/i)
      end
    end

    class Cache

      attr_accessor :sound_file

      def initialize(sound_file)
        @sound_file = sound_file
      end

      def cache_file
        "#{sound_file}.stats"
      end

      def load
        YAML.load(IO.read(cache_file)) rescue nil
      end

      def dump(attributes)
        File.open(cache_file, "w") do |f|
          f.write YAML.dump(attributes)
        end
        attributes
      end

      def fetch(&block)
        load or dump(block.call)
      end

    end

    def attributes_without_cache
      @attributes ||=
        begin
          paires = raw_values.collect do |key, _, value|
            value = value.to_f if value =~ /^-?[0-9.]+$/
            [key, value]
          end
          Hash[paires]
        end
    end

    def attributes_with_cache
      Cache.new(command.inputs.first.filename).fetch do
        attributes_without_cache
      end
    end

    def attributes
      if use_cache and command.inputs.size == 1
        attributes_with_cache
      else
        attributes_without_cache
      end
    end

    def rms_level
      attributes['RMS lev dB']
    end

    def rms_peak
      attributes['RMS Pk dB']
    end

    def peak_level
      attributes['Pk lev dB']
    end

    def silent?
      rms_peak < -45
    end

  end
end

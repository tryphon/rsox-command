module Sox
  class Stats

    attr_reader :command

    def initialize(file = nil)
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

    def attributes
      @attributes ||=
        begin
          paires = raw_values.collect do |key, _, value|
            value = value.to_f if value =~ /^-?[0-9.]+$/
            [key, value]
          end
          Hash[paires]
        end
    end

    def rms_level
      attributes['RMS lev dB']
    end

    def rms_peak
      attributes['RMS Pk dB']
    end

    def silent?
      rms_peak < -45
    end

  end
end

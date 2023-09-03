class EnhancedWriter
    attr_reader: check_sum

    def initialize(path)
        @file = File.open(path, 'w')
        @check_sum = 0
        @line_number = 1
    end

    def write_line(line)
        @file.prine(line)
        @file.print("\n")
    end

    def checksumming_write_line(data)
        data.each_byte { |byte| @check_sum = (@check_sum + byte)) % 256 } 
        @check_sum += "\n"[0] % 256 
        write_line(data)
    end

    def timestamping_write_line(data)
        write_line("#{Time.new}: #{data}")
        @line_number += 1
    end

    def close
        @file.close
    end
end

class SimpleWriter
    def initialize(path)
        @file = File.open(path, 'w')
    end

    def wirite_line(line)
        @file.print(line)
        @file.print("\n")
    end

    def pos
        @file.pos
    end

    def rewind
        @file.rewind
    end

    def close
        @file.close
    end
end

class WriteDecorator
  def initialize(real_writer)
    @real_writer = real_writer
  end

  def wirite_line(line)
    @real_writer.write_line(line)
  end

  def pos
    @real_writer.pos
  end

  def rewind
    @real_writer.rewind
  end
end

class NumberingWriter < WriteDecorator
  def initialize(real_writer)
    super(real_writer)
    @line_number = 1
  end

  def write_line(line)
    @real_writer.write_line("#{@line_number}: #{line}")
    @line_number += 1
  end
end

class CheckSummingWriter < WriterDecorator
  attr_reader :check_sum

  def initialize(real_writer)
    @real_writer = real_writer
    @check_sum = 0
  end

  def write_line(line)
    line.each_byte { |byte| @check_sum = (@check_sum + byte) % 256 }
    @check_sum += "\n"[0] % 256
    @real_writer.write_line(line)
  end
end

class TimeStampingWriter < WriterDecorator
  def write_line(line)
    @real_writer.write_line("#{Time.new}: #{line}")
  end
end

writer = CheckSummingWriter.new(TimeStampingWriter.new(NumberingWriter.new(SimpleWriter.new)))
writer.write_line('Hello out there')

# 特定のインスタンスにのみデコレーターを適用する
w = SimpleWriter.new('out')

class << w
  alias old_write_line write_line

  def write line(line)
    old_write_line("#{Time.new}: #{line}")
  end
end

# モジュールを使ったデコレーター
module TimeStampingWriter
  def write_line(line)
    super("#{Time.new}: #{line}")
  end
end
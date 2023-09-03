class Encryptor
  def initialize(key)
    @key = key
  end

  def encrypt(reader, writer)
    key_index = 0
    while not reader.eof?
      clear_char = reader.getc
      encrypted_char = clear_char.to_i ^ @key[key_index].to_i
      writer.putc(encrypted_char)
      key_index = (key_index + 1) % @key.size
    end
  end
end

reader = File.open('message.txt')
writer = File.open('message.encrypted', 'w')
encrypter = Encryptor.new('my secret key')
encrypter.encrypt(reader, writer)

# ファイルではなく文字列を使いたくなった
class StringEncryptor
  def initialize(string)
    @string = string
    @position = 0
  end

  def getc
    if @position >= @string.length
      raise EOFError
    end
    ch = @string[@position]
    @position += 1
    return ch
  end

  def eof?
    return @position >= @string.length
  end
end


# 実際に必要になるのは、既存のインターフェースと同じだがちょっと違う場合
class Renderer
  def render(text_object)
    text = text_object.text
    size = text_object.size_inches
    color = text_object.color
    # ...
  end
end

class TextObject
  attr_reader :text, :size_inches, :color

  def initialize(text, size_inches, color)
    @text = text
    @size_inches = size_inches
    @color = color
  end
end

class BritishTextObject
  attr_reader :string, :size_mm, :colour

  def initialize(string, size_mm, colour)
    @string = string
    @size_mm = size_mm
    @colour = colour
  end
end

class BritishTextObjectAdaptor < TextObject
  def initialize(bto)
    @bto = bto
  end

  def text
    bto.string
  end

  def size_inches
    bto.size_mm / 25.4
  end

  def color
    bto.colour
  end
end

# BritishTextObjectの固有のインスタンスにのみアダプタを適用する
bto = BritishTextObject.new('hello', 50.8, :blue)
class << bto
  def color
    colour
  end

  def text
    string
  end

  def size_inches
    size_mm / 25.4
  end
end


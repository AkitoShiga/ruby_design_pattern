
# ブロックを使ったcommand
class SlickButton

  attr_accessor :command

  def initialize(&block)
    @command = block
  end
end

def on_button_push
  @command.call if @command
end

new_button = SlickButton.new do
  # do something
end

# 変更を記録するコマンド
class Command
  attr_reader :description

  def initialize(description)
    @description = description
  end

  def execute
  end
end

# ファイル作成
class CreateFile < Command
  def initialize(path, contents)
    super("Create file: #{path}")
    @path = path
    @contents = contents
  end

  def execute
    f = File.open(@path, "w")
    f.write(@contents)
    f.close
  end
end

# ファイル削除
class DeleteFile < Command
  def initialize(path)
    super("Delete file: #{path}")
    @path = path
  end

  def execute
    File.delete(@path)
  end
end

# コピー
class CopyFile < Command
  def initialize(source, target)
    super("Copy file: #{source} to #{target}")
    @source = source
    @target = target
  end

  def execute
    FileUtils.copy(@source, @target)
  end
end

# コンポジットでまとめる
class CompositeCommand < Command
  def initialize
    @commands = []
  end

  def <<(command)
    @commands << command
  end

  def execute
    @commands.each{ |command| command.execute }
  end

  def description
    @commands.inject("") { |description, command| description += command.description + "\r\n" }
  end
end

cmds = CompositeCommand.new
cmds << CreateFile.new("file1.txt", "hello world\n")
cmds << CopyFile.new("file1.txt", "file2.txt")
cmds << DeleteFile.new("file1.txt")
p cmds.description
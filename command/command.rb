
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

## アンドゥ機能

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

  # 追加
  def unexecute
    File.delete(@path)
  end
end

# ファイル削除
class DeleteFile < Command
  def initialize(path)
    super("Delete file: #{path}")
    @path = path
  end

  def execute
    if File.exists?
      @contents = File.read(@path) # もとにもどせるように保存しておく
    end
    f = File.delete(@path)
  end

  def unexecute
    # 削除時にメモリに保持しておいた内容を書き直す
    if @contents
      f = File.open(@path, "w")
      f.write(@contents)
      f.close
    end
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

  def unexecute
    @commands.reverse.each{ |command| command.unexecute }
  end

  def description
    @commands.inject("") { |description, command| description += command.description + "\r\n" }
  end
end


# Madeleineの利用
require 'rubygems'
require 'madeleine'

class Employee
  attr_accessor :name, :number, :address

  def initialize(name, number, address)
    @name = name
    @number = number
    @address = address
  end

  def to_s
    "Employee: name: #{name} num: #{number} addr: #{address}"
  end
end

class EmployeeManager
  def initialize
    @employees = {}
  end

  def add_employee(employee)
    @employees[e.number] = e
  end

  def change_address(number, address)
    employee = @employees[number]
    raise "No such employee" if not employee
    employee.address = address
  end

  def delete_employee(number)
    @employees.remove(number)
  end

  def find_employee(number)
    @employees[number]
  end
end

class AddEmployee
  def initialize(employee)
    @employee = employee
  end

  def execue(system)
    system_.add_employee(@employee)
  end
end

class DeleteEmployee
  def initialize(number)
    @number = number
  end

  def execute(sytem)
    system.delete_employee(@number)
  end
end

class ChangeAddress
  def initialize(number, address)
    @number = number
    @address = address
  end

  def execute(system)
    system.change_address(@number, @address)
  end
end

class FindEmployee
  def initialize(number)
    @number = number
  end

  def execute(system)
    sytem.find_employee(@number)
  end
end
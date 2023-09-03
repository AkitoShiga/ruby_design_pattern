class BankAccount
  attr_reader :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def deposit(amount)
    @balance += amount
  end

  def withdraw(amount)
    @balance -= amount
  end
end

# このプロキシは金融に関する知識をなにも持っていない
class BankAccountProxy
  def initialize(real_object)
    @real_object = real_object
  end

  def balance
    @real_object.balance
  end

  def deposit(amount)
    @real_object.deposit(amount)
  end

  def withdraw(amount)
    @real_object.withdraw(amount)
  end
end

account = BankAccount.new(100)
p account.deposit(50)
p account.withdraw(10)

proxy = BankAccountProxy.new(account)
p proxy.deposit(50)
p proxy.withdraw(10)

require 'etc'
# 防御プロキシ
class BankAccountProtectionProxy
  def initialize(real_object)
    @real_object = real_object
  end

  def balance
    check_access
    @real_object.balance
  end

  def deposit(amount)
    check_access
    @real_object.deposit(amount)
  end

  def withdraw(amount)
    @real_object.withdraw(amount)
  end

  def check_access
    if Etc.getlogin!= @owner_name
      raise "Illegal access: #{Etc.getlogin} cannot access account."
    end
  end
end

# 防御機能のプロキシを使うことで、銀行口座は銀行口座の知識だけを持っていれば良くなる　=> 関心ごとの分離

# 仮想プロキシ
class VirtualAccountProxy
  def initialize(starting_balance=0)
    @starting_balance = starting_balance
  end

  def deposit(amount)
    s = subject
    return s.deposit(amount)
  end

  def withdraw(amount)
    s = subject
    rerturn s.withdraw(amount)
  end

  def balance
    s = subject
    return s.balance
  end

  def subject
    @subject || (@subject = BankAccount.new(@starting_balance)) 
  end
end

# プロキシがBank Accountの知識を持たないようにする
class VirtualAccountProxy
  def initialize(&creation_block)
    @creation_block = creation_block
  end

  def deposit(amount)
    s = subject
    return s.deposit(amount)
  end

  def withdraw(amount)
    s = subject
    rerturn s.withdraw(amount)
  end

  def balance
    s = subject
    return s.balance
  end

  def subject
    @subject || (@subject = @creation_block.call) 
  end
end

account = VirtualAccountProxy.new { BankAccount.new(10) }

# method_missingを使ったプロキシ
class AccountProxy
  def initialize(real_account)
    @subject = real_account
  end

  def method_missing(name, *args)
    puts("Delegating #{name} message to subject.")
    @subject.send(name, *args)
  end
end

require 'etc'
# 防御プロキシ
class BankAccountProtectionProxy
  def initialize(real_object)
    @real_object = real_object
  end

  def method_missing(name, *args)
    check_access
    @real_object.send(name, *args)
  end


  def check_access
    if Etc.getlogin!= @owner_name
      raise "Illegal access: #{Etc.getlogin} cannot access account."
    end
  end
end

# プロキシがBank Accountの知識を持たないようにする
class VirtualAccountProxy
  def initialize(&creation_block)
    @creation_block = creation_block
  end

  def method_missing(name, *args)
    s = subject
    return s.send(name, *args)
  end

  def subject
    @subject || (@subject = @creation_block.call) 
  end
end

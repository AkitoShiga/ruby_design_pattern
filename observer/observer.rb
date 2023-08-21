# 状態の変更を検知する
# Employee給与の変更を関心のあるオブジェクトとに通知する

# Employeeの原型
# class Employee
#   attr_reader :name
#   attr_accessor :title, :salary

#   def initialize(name, title, salary)
#     @name = name
#     @title = title
#     @salary = salary
#   end
# end

# fred = Employee.new('Fred', 'Crane Operator', 30000.0)

# フレッドを昇給させる
# fred.salary = 35000.0

# 給料の変更を経理部門に通知する

class Payroll
  def update(changed_employee)
    puts("#{changed_employee.name}のために小切手を切ります！")
    puts("彼の給料は#{changed_employee.salary}です！")
  end
end

# class Employee
#   attr_reader :name, :title
#   attr_accessor :salary

#   def initialize(name, title, salary, payroll)
#     @name = name
#     @title = title
#     @salary = salary
#     @payroll = payroll
#   end

#   def salary=(new_salary)
#     @salary = new_salary
#     @payroll.update(self)
#   end
# end

# payroll = Payroll.new
# fred = Employee.new('Fred', 'Crane Operator', 30000.0, payroll)
# フレッドを昇給させる
# fred.salary = 35000.0

# 何が問題なのか
# Emproyeeクラスの中にPayrollがハードコーディングされている
# 経理部門だけでなく、銀行や税務署などの関心のあるオブジェクトが増えた場合に、Employeeクラスを変更する必要がある
# EmployeeがPayrollの実装に依存している


# Payrollを抽象化して観察者とする
# class Employee
#   attr_reader :name, :title
#   attr_accessor :salary, :observers

#   def initialize(name, title, salary)
#     @name = name
#     @title = title
#     @salary = salary
#     @observers = []
#   end

#   def salary=(new_salary)
#     @salary = new_salary
#     notify_observers # 変更の通知に対してhookする
#   end

#   def add_observer(observer)
#     @observers << observer
#   end

#   def delete_observer(observer)
#     @observers.delete(observer)
#   end

#   private

#   # 観察者に変更があったことを通知する
#   def notify_observers
#     @observers.each do |observer|
#       observer.update(self) # 観察者がselfを引数にしたupdateメッセージに応答することのみの知識を持つ
#     end
#   end
# end

class TaxMan
  def update(changed_employee)
    puts("#{changed_employee.name}に新しい税金の請求書を送ります！")
  end
end


# fred = Employee.new('Fred', 'Crane Operator', 30000.0)

# 観察者
# payroll = Payroll.new
# tax = TaxMan.new

# Fredに関心のある観察者を登録する
# fred.add_observer(tax)
# fred.add_observer(payroll)
# fred.salary = 35000.0

# Subjectの責務を分離する
# class Subject
#   def initialize
#     @observers = []
#   end

#   def add_observer(observer)
#     @observers << observer
#   end

#   def remove_observer(observer)
#     @observers.delete(observer) 
#   end

#   def notify_observers
#     @observers.each do |observer|
#       observer.update(self)
#     end
#   end
# end

# class Employee < Subject
#   attr_reader :name, :address, :salary

#   def initialize(name, address, salary)
#     super()
#     @name = name
#     @address = address
#     @salary = salary
#   end

#   def salary=(new_salary)
#     @salary = new_salary
#     notify_observers
#   end
# end

# fred = Employee.new('Fred', 'Crane Operator', 30000.0)

# # 観察者
# payroll = Payroll.new
# tax = TaxMan.new

# # Fredに関心のある観察者を登録する
# fred.add_observer(tax)
# fred.add_observer(payroll)
# fred.salary = 35000.0

# よりRubyらしくする
# Subjectモジュールを作成する
# 継承はスーパークラスの可能性を奪ってしまう

# module Subject
#   def initialize
#     @observers = []
#   end

#   def add_observer(observer)
#     @observers << observer
#   end

#   def remove_observer(observer)
#     @observers.delete(observer) 
#   end

#   def notify_observers
#     @observers.each do |observer|
#       observer.update(self)
#     end
#   end
# end

# class Employee
#   include Subject
#   attr_reader :name, :address, :salary

#   def initialize(name, address, salary)
#     super()
#     @name = name
#     @address = address
#     @salary = salary
#   end

#   def salary=(new_salary)
#     @salary = new_salary
#     notify_observers
#   end
# end

# fred = Employee.new('Fred', 'Crane Operator', 30000.0)

# # 観察者
# payroll = Payroll.new
# tax = TaxMan.new

# # Fredに関心のある観察者を登録する
# fred.add_observer(tax)
# fred.add_observer(payroll)
# fred.salary = 35000.0

# 標準ライブラリのObservableを使う
# require 'observer'
# class Employee
#   include Observable
#   attr_reader :name, :address, :salary

#   def initialize(name, address, salary)
#     super()
#     @name = name
#     @address = address
#     @salary = salary
#   end

#   def salary=(new_salary)
#     @salary = new_salary
#     changed # 本当に状態が変更されたか確認する
#     notify_observers(self)
#   end
# end

# 観察者をコードブロックにする
module Subject
  def initialize
    @observers = [] # Procオブジェクトを格納する
  end

  def add_observer(&observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |observer|
      observer.call(self) # Procオブジェクトを呼び出す
    end
  end
end

class Employee
  include Subject

  attr_reader :name, :address, :salary
  def initialize(name, title, salary)
    super()
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end
end

# # 観察者をコードブロックとして渡す
# fred = Employee.new('Fred', 'Crane Operator', 30000.0)
# fred.add_observer do |changed_employee|
#   puts("Cut a new check for #{changed_employee.name}!")
#   puts("His salary is now #{changed_employee.salary}!")
# end

# fred.salary = 35000.0

# 

# # 不必要な通知を避ける
# module Subject
#   def initialize
#     @observers = [] # Procオブジェクトを格納する
#   end

#   def add_observer(&observer)
#     @observers << observer
#   end

#   def delete_observer(observer)
#     @observers.delete(observer)
#   end

#   def notify_observers
#     @observers.each do |observer|
#       observer.call(self) # Procオブジェクトを呼び出す
#     end
#   end
# end

# class Employee
#   include Subject

#   attr_reader :name, :address, :salary
#   def initialize(name, title, salary)
#     super()
#     @name = name
#     @title = title
#     @salary = salary
#   end

#   def salary=(new_salary)
#     old_salary = @salary
#     @salary = new_salary
#     if old_salary != new_salary
#       notify_observers
#     end
#   end
# end

# 観察者をコードブロックとして渡す
# fred = Employee.new('Fred', 'Crane Operator', 30000.0)
# fred.add_observer do |changed_employee|
#   puts("Cut a new check for #{changed_employee.name}!")
#   puts("His salary is now #{changed_employee.salary}!")
# end

# fred.salary = 30000.0 # 通知されない
# fred.salary = 35000.0 # 通知される

# 複数の変更をサポートする
class Employee
  include Subject

  attr_reader :name, :address, :salary
  def initialize(name, title, salary)
    super()
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    old_salary = @salary
    @salary = new_salary
    if old_salary != new_salary
      notify_observers
    end
  end

  def title=(new_title)
    old_title = @title
    @title = new_title
    if old_title != new_title
      notify_observers
    end
  end
end

fred = Employee.new('Fred', 'Crane Operator', 30000.0)
fred.add_observer do |changed_employee|
  puts("Cut a new check for #{changed_employee.name}!")
  puts("His salary is now #{changed_employee.salary}!")
end

# 大出世
# fred.salary = 100000.0
# 少しの間高級取りのクレーンオペレーターとなる
# fred.title = 'Vice President of Sales'


class Employee
  include Subject

  attr_reader :name, :address, :salary
  def initialize(name, title, salary)
    super()
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    old_salary = @salary
    @salary = new_salary
    # if old_salary != new_salary
    #   notify_observers
    # end
  end

  def title=(new_title)
    old_title = @title
    @title = new_title
    # if old_title != new_title
    #   notify_observers
    # end
  end
end

fred = Employee.new('Fred', 'Crane Operator', 30000.0)
fred.add_observer do |changed_employee|
  puts("Cut a new check for #{changed_employee.name}!")
  puts("His salary is now #{changed_employee.salary}!")
end

# 大出世
fred.salary = 100000.0
fred.title = 'Vice President of Sales'
fred.notify_observers


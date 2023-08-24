# 基底クラス
class Task
  attr_reader :name

  # タスク名
  def initialize(name)
    @name = name
  end

  # 各タスクの所要時間
  def get_time_required
    0.0
  end
end

# 末端のLeaf
class AddDryIngredientsTask < Task

  def initialize
    super('Add dry ingredients')
  end

  def get_time_required
    1.0 # 小麦粉と砂糖を加えるのに1分
  end
end

class AddLiquidsTask < Task

  def initialize
    super('Add liquids')
  end

  def get_time_required
    2.0
  end
end

class MixTask < Task

  def initialize
    super('Mix that batter up!')
  end

  def get_time_required
    3.0 # 混ぜるのに3分
  end
end

# 中間のComposite
class MakeBatterTask < Task

  def initialize
    super('Make batter')
    @sub_tasks = []
    add_sub_task(AddDryIngredientsTask.new)
    add_sub_task(AddLiquidsTask.new)
    add_sub_task(MixTask.new)
  end

  def add_sub_task(task)
    @sub_tasks << task
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
  end

  def get_time_required
    time = 0.0
    @sub_tasks.each{ |task| time += task.get_time_required }
    time
  end
end

task = MakeBatterTask.new

# タスクの管理用のクラスを作る
class CompositeTask < Task

  def initialize(name)
    super(name)
    @sub_tasks = []
  end

  def add_sub_task(task)
    @sub_tasks << task
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
  end

  def get_time_required
    time = 0.0
    @sub_tasks.each { |task| time += task.get_time_required }
    time
  end
end


class MakeBatterTask < Task

  def initialize
    super('Make batter')
    @sub_tasks = []
    add_sub_task(AddDryIngredientsTask.new)
    add_sub_task(AddLiquidsTask.new)
    add_sub_task(MixTask.new)
  end
end

a = MakeBatterTask.new
a.add_sub_task(MakeBatterTask.new)
a.add_sub_task(MakeBatterTask.new)
a.add_sub_task(MakeBatterTask.new)
a.add_sub_task(MakeBatterTask.new)
a.add_sub_task(MakeBatterTask.new)
a.add_sub_task(MakeBatterTask.new)
b = MakeBatterTask.new
b.add_sub_task(MakeBatterTask.new)
b.add_sub_task(MakeBatterTask.new)
b.add_sub_task(MakeBatterTask.new)
b.add_sub_task(MakeBatterTask.new)
b.add_sub_task(MakeBatterTask.new)
b.add_sub_task(MakeBatterTask.new)
a.add_sub_task(b)
p a.get_time_required
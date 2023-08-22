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

class AddDryIngredientsTask < Task

  def initialize
    super('Add dry ingredients')
  end

  def get_time_required
    1.0 # 小麦粉と砂糖を加えるのに1分
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


class Duck
  def initialize(name)
    @name = name
  end

  def eat
    puts("アヒル#{@name}食事中です。")
  end

  def speak
    puts("アヒル#{@name}がガーガー鳴いています。")
  end

  def sleep
    puts("アヒル#{@name}は静かに眠っています。")
  end
end

class Pond
  def initialize(number_ducks)
    @ducks = []
    number_ducks.times do |i|
      duck = Duck.new("アヒル#{i}")
      @ducks << duck
    end
  end

  def simulate_one_day
    @ducks.each{ |duck| duck.speak }
    @ducks.each{ |duck| duck.eat }
    @ducks.each{ |duck| duck.sleep }
  end
end

pond = Pond.new(3)
pond.simulate_one_day

class Frog
  def initialize(name)
    @name = name
  end

  def eat
    puts("カエル#{@name}は食事中です。")
  end

  def speak
    puts("カエル#{@name}はゲロゲロッと鳴いています。")
  end

  def sleep
    puts("カエル#{@name}は眠りません。一晩中ゲロゲロ鳴いています。")
  end
end

# 変わらない池と変わる動物を分離する
#　template_methodを使ってクラスの選択をサブクラスに押し付ける
class Pond
  def initialize(number_animals)
    @animals = []
    number_animals.times do |i|
      animal = new_animal("動物#{i}")
      @animals << animal
    end
  end

  def simulate_one_day
    @animals.each{ |animal| animal.speak }
    @animals.each{ |animal| animal.eat }
    @animals.each{ |animal| animal.sleep }
  end
end

class DuckPond < Pond
  def new_animal(name)
    Duck.new(name)
  end
end

class FrogPond < Pond
  def new_animal(name)
    Frog.new(name)
  end
end

# pond = FrogPond.new(3)
# pond.simulate_one_day

# 池に植物を追加する
class Algae
  def initialize(name)
    @name = name
  end

  def grow
    puts("藻#{@name}は日光を浴びて育ちます。")
  end
end

class WaterLily
  def initialize(name)
    @name = name
  end

  def grow
    puts("睡蓮#{@name}は浮きながら日光を浴びて育ちます。")
  end
end

# 池に植物を追加する
class Pond
  def initialize(number_animals)
    @animals = []
    number_animals.times do |i|
      animal = new_animal("動物#{i}")
      @animals << animal
    end

    @plants = []
    number_plants.times do |i|
      plant = new_plant("動物#{i}")
      @plants << plant
    end
  end

  def simulate_one_day
    @plants.each{ |plant| plant.grow } 
    @animals.each{ |animal| animal.speak }
    @animals.each{ |animal| animal.eat }
    @animals.each{ |animal| animal.sleep }
  end
end

# Pondのサブクラスにも修正が必要
class DuckWaterLilyPond < Pond
  def new_animal(name)
    Duck.new(name)
  end

  def new_plant(name)
    WaterLily.new(name)
  end
end

class FrogAlgaePond < Pond

  def new_animal(name)
    Frog.new(name)
  end

  def new_plant(name)
    Algae.new(name)
  end
end
# 作り出すオブジェクトの種類をサブクラスに押し付けると型の組み合わせの数だけサブクラスを作らなければいけなくなってしまうため、使いにくくなる

# パラメータ化されたファクトリメソッドを使用する
class Pond
  def initialize(namuber_animals, number_plants)
    @animals = []
    number_animals.time do |i|
      animal = new_organism(:animal, "動物#{i}")
      @animals << animal
    end

    @plants = []
    number_plants.time do |i|
      plant = new_organism(:plant, "植物#{i}")
      @plants << plant
    end
  end
end

# 新しい種族の追加はメソッドだけになりクラスを作らなくても良くなる
# ただしこのパターンが作るオブジェクトのパターンごとに別々のサブクラスを作る必要がある
class DuckWaterLilyPond
  def new_organism(type, name)
    if type == :animal
      Duck.new(name)
    elsif type == :plant
      WaterLily.new(name)
    else
      raise "Unknown organism type: #{type}" 
    end
  end
end


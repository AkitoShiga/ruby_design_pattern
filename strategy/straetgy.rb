#  レポートの出力とフォーマットを分離する
# 同一の目的があり、それを達成するための戦略が複数ある場合に利用する
# has a の関係になる

class Report
  def initialize(formatter)
    @title = '月次報告'
    @text = ['順調', '最高の調子']
    @formatter = formatter
  end
  attr_writer :formatter
  attr_reader :title, :text

  def output_report
    @formatter.output_report(@title, @text)
  end
end

class Formatter
  def output_report(title, text)
    puts('<html>')
    puts('  <head>')
    puts("    <title>#{title}</title>")
    puts('  </head>')
    puts('  <body>')
    text.each do |line|
        puts("    <p>#{line}</p>")
    end
    puts('  </body>')
    puts('</html>')
  end
end

class PlainTextFormatter
  def output_report(title, text)
    puts("*** #{title} ***")
    text.each do |line|
      puts(line)
    end
  end
end

# template methodはクラスそのものをインスタンス化するが、strategyはインスタンスを渡す
# report = Report.new(Formatter.new)
# report.output_report
# report.formatter = PlainTextFormatter.new
# report.output_report

# 改良版、引数に Report クラスを渡す
class Report
  def initialize(formatter)
    @title = '月次報告'
    @text = ['順調', '最高の調子']
    @formatter = formatter
  end
  attr_writer :formatter

  def output_report
    @formatter.output_report(self)
  end
end

class Formatter
  def output_report(context)
    puts('<html>')
    puts('  <head>')
    puts("    <title>#{context.title}</title>")
    puts('  </head>')
    puts('  <body>')
    context.text.each do |line|
        puts("    <p>#{line}</p>")
    end
    puts('  </body>')
    puts('</html>')
  end
end

class PlainTextFormatter
  def output_report(context)
    puts("*** #{context.title} ***")
    context.text.each do |line|
      puts(line)
    end
  end
end

# report = Report.new(Formatter.new)
# report.output_report
# report.formatter = PlainTextFormatter.new
# report.output_report

# 改良版、Procを渡す
class Report
  def initialize(&formatter) # BlockをProcに変換
    @title = '月次報告'
    @text = ['順調', '最高の調子']
    @formatter = formatter
  end
  attr_writer :formatter

  def output_report
    @formatter.call(self)
  end
end

HTML_FORMATTER = lambda do |context|
  puts('<html>')
  puts('<html>')
  puts('  <head>')
  puts("    <title>#{context.title}</title>")
  puts('  </head>')
  puts('  <body>')
  context.text.each do |line|
      puts("    <p>#{line}</p>")
  end
  puts('  </body>')
  puts('</html>')
  end

report = Report.new &HTML_FORMATTER # Blockを展開
report.output_report
report = Report.new do |context| # Blockを渡す
  puts("*** #{context.title} ***")
  context.text.each do |line|
    puts(line)
  end
end
report.output_report
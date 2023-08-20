# 月次の状況報告を出力する
class Report
  def initialize
    @title = '月次報告'
    @text = ['順調', '最高の調子']
  end

  def output_report
    puts('<html>')
    puts('  <head>')
    puts("    <title>#{@title}</title>")
    puts('  </head>')
    puts('  <body>')
    @text.each do |line|
      puts("    <p>#{line}</p>")
    end
    puts('  </body>')
    puts('</html>')
  end
end

#report = Report.new
#report.output_report

# HTMLだけではなく、プレーンテキストでも出力が必要になった
# 変化しない部分（処理の流れ）と変化する部分（出力形式）が混ざり合っており、デザインパターンの基本原則に反している
class Report
  def initialize
    @title = '月次報告'
    @text = ['順調', '最高の調子']
  end

  def output_report(format)
    if format == :plain
      puts("*** #{@title} ***")
    elsif format == :html
      puts('<html>')
      puts('  <head>')
      puts("    <title>#{@title}</title>")
      puts('  </head>')
      puts('  <body>')
    else
      raise "Unknow format #{format}"
    end
    @text.each do |line|
      if format == :plain
        puts(line)
      else
        puts("    <p>#{line}</p>")
      end
    end
    if format == :html
      puts('  </body>')
      puts('</html>')
    end
  end
end

# report = Report.new
# report.output_report(:html)
# report.output_report(:plain)
# report.output_report(:json)

class Report
  def initialize
    @title = '月次報告'
    @text = ['順調', '最高の調子']
  end

  def output_report
    output_start
    output_head
    output_body_start
    output_body
    output_body_end
    output_end
  end

  def output_body
    @text.each do |line|
      output_line(line)
    end
  end

  def output_start
    raise 'Called abstract method: output_start'
  end

  def output_head
    raise 'Called abstract method output_head'
  end

  def body_start
    raise 'Called abstract method body_start'
  end

  def output_line(line)
    raise 'Called abstract method output_line'
  end

  def output_body_end
    raise 'Called abstract method output_body_end'
  end

  def output_end
    raise 'Called abstract method output_end'
  end
end

class HTMLReport < Report
  def output_start
    puts('<html>')
  end

  def output_head
    puts('  <head>')
    puts("    <title>#{@title}</title>")
    puts('  </head>')
  end

  def output_body_start
    puts('<body>')
  end

  def output_line(line)
    puts("  <p>#{line}</p>")
  end

  def output_body_end
    puts('</body>')
  end

  def output_end
    puts('</html>')
  end
end

class PlainTextReport < Report
  def output_start
  end

  def output_head
    puts("***#{@title}***")
  end

  def output_body_start
  end

  def output_body_start
  end

  def output_line(line)
    puts line
  end

  def output_body_end
  end

  def output_end
  end
end

# report = HTMLReport.new
# report.output_report

# report2 = PlainTextReport.new
# report2.output_report

# 使わないメソッドをいちいちオーバーライドするのは面倒なので、必要な部分だけオーバーライドできるようにする
class Report
  def initialize
    @title = '月次報告'
    @text = ['順調', '最高の調子']
  end

  def output_report
    output_start
    output_head
    output_body_start
    output_body
    output_body_end
    output_end
  end

  def output_body
    @text.each do |line|
      output_line(line)
    end
  end

  def output_start
  end

  def output_head
    output_line(@title) # 必要に応じてオーバーライドしてもらう
  end

  def output_body_start
  end

  def output_line(line)
    raise 'Called abstract method output_line' # オーバーライド必須
  end

  def output_body_end
  end

  def output_end
  end
end

# 手順
# 最初に一つのものに集中する
# Reportを具象クラスに
# 具象のReportの処理を分割してテンプレートメソッドが適用できるようにする
# Reportのサブクラスに具象を移して　元のReportを抽象クラスにする
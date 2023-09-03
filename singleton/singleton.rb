class SimpleLogger

    @@instance = SimpleLogger.new

    def self.instance
        return @@instance
    end

    # 既存のクラスメソッドをprivateにする
    private_class_method :new
end
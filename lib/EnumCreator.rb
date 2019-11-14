class ValueIsNotIntegerError < Exception
end

class EnumCreator
  attr_accessor :enum_instance, :counter, :enum_name, :enum_definition
  def initialize(name, &definicion)
    self.enum_instance = Class.new
    self.counter = 1
    self.enum_name = name
    self.enum_definition = definicion
  end

  def create()
    self.instance_exec &enum_definition
    Object.const_set(enum_name, enum_instance)
  end

  def create_class_for_value(name, numeric_value)
    nueva_clase = Class.new
    enum_name = self.enum_name
    nueva_clase.define_method(:valor) { numeric_value }
    nueva_clase.define_method(:to_s) { "#{enum_name}.#{name}" }
    nueva_clase
  end

  def method_missing(name, *args, &block)
    if args[0].nil?
      enum_value = create_class_for_value(name, counter).new
      self.counter = self.counter + 1
    elsif args[0].is_a? Integer
      enum_value = create_class_for_value(name, args[0]).new
      self.counter = args[0] + 1
    else
      raise ValueIsNotIntegerError
    end

    enum_instance.define_singleton_method(name) do
      enum_value
    end
  end
end

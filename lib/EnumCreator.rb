class ValueIsNotIntegerError < Exception
end

class InvalidEnumValueError < Exception
end


class Enum
  include Enumerable
  attr_reader :to_s

  def initialize(name, &definicion)
    @to_s = name
    @valorAbstracto = ValorAbstracto.new(self, &definicion)
  end

  def get_value(name)
    self.send(name)
  end

  def each(&block)
    @valorAbstracto.valores.each_value &block
  end

  def modificar(&block)
    @valorAbstracto.modificar(&block)
  end

  def method_missing(name, *args, &block)
    raise InvalidEnumValueError
  end
end

class ValorDeEnum
  def initialize(valor, name, comportamiento)
    @valor = valor
    @name = name
    @comportamiento = comportamiento
  end

  def valor
    @valor
  end

  def to_s
    "#{@comportamiento.enum.to_s}.#{@name}"
  end

  def method_missing(name, *args, &block)
    @comportamiento.send(name, *args, &block)
  end
end

class ValorAbstracto
  attr_accessor :enum, :valores
  def initialize(enum_instance, &definicion)
    self.enum = enum_instance
    self.valores = Hash.new
    self.singleton_class.instance_variable_set("@max_value", 0)
    self.singleton_class.instance_variable_set("@enum", enum_instance)
    self.singleton_class.instance_variable_set("@instance", self)
    self.singleton_class.instance_variable_set("@valores", self.valores)
    self.modificar(&definicion)
  end

  def modificar(&definicion)
    self.singleton_class.instance_variable_set("@en_creacion", true)
    self.singleton_class.class_exec &definicion unless definicion.nil?
    self.singleton_class.instance_variable_set("@en_creacion", false)
  end

  def self.method_missing(name, *args, &block)
    return super unless @en_creacion

    if args[0].nil?
      @max_value += 1
    elsif args[0].is_a? Integer
      @max_value = args[0]
    else
      raise ValueIsNotIntegerError
    end

    enum_value = ValorDeEnum.new(@max_value, name, @instance)
    enum_value.singleton_class.class_exec &block unless block.nil?
    @valores[name] = enum_value

    #Esto podria hacer con method_missing y el hash de valores,
    # cuando lo hice no habia pensado la parte de polimorfismo
    # con Enumerable
    @enum.define_singleton_method(name) do
      enum_value
    end
  end
end
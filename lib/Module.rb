require_relative 'EnumCreator'

class Module
  def enum(nombre, &definicion)
    self.const_set(nombre, Enum.new(nombre, &definicion))
  end
end

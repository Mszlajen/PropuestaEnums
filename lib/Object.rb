require_relative 'EnumCreator'

class Object
  def self.enum(nombre, &definicion)
    Object.const_set(nombre, Enum.new(nombre, &definicion))
  end
end

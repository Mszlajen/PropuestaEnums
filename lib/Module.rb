require_relative 'EnumCreator'

class Module
  def enum(nombre, &definicion)
    EnumCreator.new(nombre, &definicion).create
  end
end

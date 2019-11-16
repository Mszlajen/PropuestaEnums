require_relative 'EnumCreator'

class Module
  def enum(nombre, &definicion)
    if nombre.is_a?(Symbol) && const_defined?(nombre)
      const_get(nombre).modificar(&definicion)
    else
      self.const_set(nombre, Enum.new(nombre, &definicion))
    end

  end
end

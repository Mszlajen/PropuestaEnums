require_relative 'EnumCreator'

class Module
  def enum(name, &definicion)
    if name.is_a? Enum
      name.modificar(&definicion)
    elsif name.is_a? Symbol
      if const_defined?(name) && const_get(name).is_a?(Enum)
        const_get(name).modificar(&definicion)
      else
        self.const_set(name, Enum.new(name, &definicion))
      end
    else
      raise TypeError.new("#{name.class} is not a valid type for a enum name")
    end

  end
end

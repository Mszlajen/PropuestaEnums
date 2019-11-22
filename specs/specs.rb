require 'rspec'
require_relative '../lib/enum'

RSpec.describe "test de enums" do
  context "Funcionalidad basica de enum" do
    class Object
      enum :EnumBasico do
        valor1
        valor2
        valor4 4
        valor5
      end
    end

    it "igualdad" do
      llamadoUno = EnumBasico.valor1
      llamadoDos = EnumBasico.valor1

      expect(llamadoUno).to be llamadoDos
    end

    it "valor numerico por defecto" do
      expect(EnumBasico.valor1.valor).to be 1
      expect(EnumBasico.valor2.valor).to be 2
    end

    it "valor numerico cambiado" do
      expect(EnumBasico.valor4.valor).to be 4
    end

    it "valor numerico queda corrido" do
      expect(EnumBasico.valor5.valor).to be 5
    end

    it "to_s" do
      expect(EnumBasico.valor1.to_s).to eq "EnumBasico.valor1"
    end

    it "falla si cambio valor a algo no entero" do
      proc = Proc.new do
        class Object
          enum :UnEnum do
            valor "to_s"
          end
        end
      end
      expect(&proc).to raise_error ValueIsNotIntegerError
    end

    it "falla si pido un valor que no existe" do
      expect {EnumBasico.valorInexistente}.to raise_error InvalidEnumValueError
    end
  end

  context "comportamiento" do
    class Object
      enum :EnumSaludadora do
        persona1 do
          def despedirse
            "adiosito"
          end
        end
        persona2

        def saludar
          "hola"
        end
        def despedirse
          "adios"
        end
      end
    end

    it "ambos valores entienden saludar" do
      expect(EnumSaludadora.persona1.saludar).to eq("hola")
      expect(EnumSaludadora.persona2.saludar).to eq("hola")
    end

    it "persona1 se despide diferente" do
      expect(EnumSaludadora.persona1.despedirse).to eq("adiosito")
      expect(EnumSaludadora.persona2.despedirse).to eq("adios")
    end
  end

  context "get_value" do
    class Object
      enum :Valores do
        primero
        segundo
        tercero
      end
    end

    it "obtiene el valor" do
      expect(Valores.get_value(:primero)).to be Valores.primero
    end

    it "rompe si no obtiene el valor" do
      expect{ Valores.get_value(:negativo) }.to raise_error InvalidEnumValueError
    end
  end

  context "polimorfismo con enumarable" do
    class Object
      enum :EnumPolimorfico do
        primero
        segundo
        tercero
        quinto 5
      end
    end

    it "each" do
      list = []
      EnumPolimorfico.each { |valor| list << valor }
      expect(list).to contain_exactly(EnumPolimorfico.primero, EnumPolimorfico.segundo, EnumPolimorfico.tercero, EnumPolimorfico.quinto)
    end

    it "all?" do
      expect(EnumPolimorfico.all? {|valor| valor.valor < 5}).to be false
    end

    it "any?" do
      expect(EnumPolimorfico.any? {|valor| valor.valor < 5}).to be true
    end
  end

  context "Constante en contexto" do
    class UnaClase
      enum :MiEnum
    end

    it "MiEnum no existe en el contexto general" do
      expect{MiEnum}.to raise_error NameError
    end

    it "MiEnum existe en el interior de UnaClase" do
      expect{UnaClase::MiEnum}.not_to raise_error
    end
  end

  context "Enum abiertos" do
    class Object
      enum :EnumAbierto do
        falso do
          def se_piso_valor?
            false
          end
        end
        falso_cambiado_a_verdadero do
          def se_piso_valor?
            false
          end
        end
        verdadero
        def se_piso_valor?
          true
        end

        def se_piso_enum?
          false
        end

      end

      enum :EnumAbierto do
        falso_cambiado_a_verdadero
        valor_agregado

        def se_piso_enum?
          true
        end
      end

      enum EnumAbierto do
        def funciona_con_constante?
        end
      end
    end

    it "funciona con constante" do
      expect{EnumAbierto.verdadero.funciona_con_constante?}.not_to raise_error
    end

    it "se agrego un nuevo valor" do
      expect{EnumAbierto.valor_agregado}.not_to raise_error
    end

    it "se piso metodo de enum" do
      expect(EnumAbierto.falso.se_piso_enum?).to be true
      expect(EnumAbierto.verdadero.se_piso_enum?).to be true
    end

    it "se piso valor es verdad" do
      expect(EnumAbierto.falso_cambiado_a_verdadero.se_piso_valor?).to be true
    end
  end
end
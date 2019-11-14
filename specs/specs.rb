require 'rspec'
require_relative '../lib/enum'

RSpec.describe "test de enums" do
  context "Funcionalidad basica de enum" do
    enum :MiEnum do
      valor1
      valor2
      valor4 4
    end

    it "igualdad" do
      llamadoUno = MiEnum.valor1
      llamadoDos = MiEnum.valor1

      expect(llamadoUno).to be llamadoDos
    end

    it "valor numerico por defecto" do
      expect(MiEnum.valor1.valor).to be 1
      expect(MiEnum.valor2.valor).to be 2
    end

    it "valor numerico cambiado" do
      expect(MiEnum.valor4.valor).to be 4
    end

    it "to_s" do
      expect(MiEnum.valor1.to_s).to eq "MiEnum.valor1"
    end

  end
end
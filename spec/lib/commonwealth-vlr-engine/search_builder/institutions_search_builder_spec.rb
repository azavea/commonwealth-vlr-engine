require 'spec_helper'

describe CommonwealthInstitutionsSearchBuilder do

  class CommonwealthInstitutionsSearchBuilderTestClass < CommonwealthInstitutionsSearchBuilder
  end

  before { @obj = CommonwealthInstitutionsSearchBuilderTestClass.new(CatalogController.new) }

  describe 'processor chain' do

    it 'should add the right methods to the processor chain' do
      expect(@obj.processor_chain).to include(:institutions_filter)
    end

  end


end
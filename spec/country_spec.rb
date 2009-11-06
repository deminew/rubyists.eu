require File.join(File.dirname(__FILE__), 'spec_helper')

describe Country do
  context 'as a class' do
    before :all do
      @class = Country
    end
    
    it_should_behave_like 'A Model::Base class'
  end
  
  context 'when the data model have been just defined' do
    before :each do
      Country.clear unless Country.empty?
    end
    
    it 'should have no data.' do
      Country.should be_empty
    end
    
    it 'should allow to save a new country with a defined 2-letter uppercased code and a name.' do
      country = Country.new(:code => 'XX', :name => 'Test Country')
      
      country.should be_an_instance_of(Country)
      country.code.should be_an_instance_of(String)
      country.code.should =~ PATTERN_CODE
      country.name.should be_an_instance_of(String)
      
      country.save
      
      saved_country = Country.get(country.code)
      
      saved_country.should be_an_instance_of(Country)
      saved_country.code.should == country.code
      saved_country.name.should == country.name
    end
    
    it 'should not save a new country when any piece of data does not match the defined criteria.' do
      countries = [{:code => 'X', :name => 'Test Country'}, {:code => 'Xx', :name => 'Test Country'}, 
                   {:code => 'X0', :name => 'Test Country'}, {:code => 'XXX', :name => 'Test Country'}, 
                   {:code => nil, :name => 'Test Country'}, {:code => 'XX', :name => nil}, 
                   {:code => 'XX', :name => 'test country'}, {:code => 'XX', :name => 'TEST COUNTRY'}, {:code => nil, :name => nil}]
                   
      countries.each do |country|
        test_country = Country.new(:code => country[:code], :name => country[:name])
        
        test_country.should be_an_instance_of(Country)
        
        unless country[:code].nil?
          test_country.code.should be_an_instance_of(String)
           country[:code].length == 2 ? test_country.code.length.should == 2 : 
                                        test_country.code.length.should_not == 2
           (country[:code] =~ PATTERN_CODE).nil? ? test_country.code.should_not =~ PATTERN_CODE :
                                                   test_country.code.should =~ PATTERN_CODE
        end
        
        unless country[:name].nil?
          test_country.name.should be_an_instance_of(String)
          (country[:name] =~ PATTERN_NAME).nil? ? test_country.name.should_not =~ PATTERN_NAME :
                                                  test_country.name.should =~ PATTERN_NAME
        end
        
        test_country.save
        
        Country.get(test_country.code).should be_nil
      end
    end
     
    it 'should populate its possible values from a comma-separated file.' do
      Country.populate
      Country.should_not be_empty
    end

    it 'should be able to destroy all countries' do
      Country.create(:code => 'NL', :name => 'Netherlands')
      Country.count.should == 1
      Country.clear
      Country.count.should == 0
    end
    
    it 'should know if there are no countries' do
      Country.should be_empty
      Country.create(:code => 'NL', :name => 'Netherlands')
      Country.should_not be_empty
    end
  end
end

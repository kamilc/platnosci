# Bramka dla Spree do uzywania serwisu platnosci.pl 

module Spree
  
  class PlatnosciGateway
    
    def initialize(options = { })
      
    end
    
    def authorize(money, creditcard, options = {})      
      
    end

    def purchase(money, creditcard, options = {})
      
    end 

    def credit(money, ident, options = {})
      
    end
 
    def capture(money, ident, options = {})
      
    end
    
    def void(ident, options = {})
      
    end
    
  end
  
end
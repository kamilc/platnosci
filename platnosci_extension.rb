# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class PlatnosciExtension < Spree::Extension
  version "1.0"
  description "Integracja z serwisem Platnosci.pl"
  url ""

  # Please use platnosci/config/routes.rb instead for extension routes.

  # def self.require_gems(config)
  #   config.gem "gemname-goes-here", :version => '1.2.3'
  # end
  
  def activate

    # Add your extension tab to the admin.
    # Requires that you have defined an admin controller:
    # app/controllers/admin/yourextension_controller
    # and that you mapped your admin in config/routes
    
    AppConfiguration.class_eval do
      preference :pos_id, :string, :default => '18999'
      preference :pos_auth_key, :string, :default => '5rXHHtm'
      preference :key1, :string, :default => '78397a875969f6b90084732319fd5227'
      preference :key2, :string, :default => '833e70323219f5d072e9e6e940a739fe'
    end
    
    UserSessionsController.class_eval do
      helper :products
    end

    # Admin::BaseController.class_eval do
    #   before_filter :remove_payment_step
    # 
    #   def remove_payment_step
    #     Spree::Config[:auto_capture] = true
    #   end
    # end

    # make your helper avaliable in all views
    # Spree::BaseController.class_eval do
    #   helper YourHelper
    # end
  end
end

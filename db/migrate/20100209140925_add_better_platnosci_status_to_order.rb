class AddBetterPlatnosciStatusToOrder < ActiveRecord::Migration
  def self.up
    remove_column :orders, :platnosci_status
    add_column :orders, :platnosci_status, :string, :default => 'Nowo wprowadzone'
  end

  def self.down
    remove_column :orders, :platnosci_status
    add_column :orders, :platnosci_status, :string
  end
end
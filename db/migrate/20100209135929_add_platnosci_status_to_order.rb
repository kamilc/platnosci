class AddPlatnosciStatusToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :platnosci_status, :string
  end

  def self.down
    remove_column :orders, :platnosci_status
  end
end
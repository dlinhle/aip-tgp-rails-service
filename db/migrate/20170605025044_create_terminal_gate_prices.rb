class CreateTerminalGatePrices < ActiveRecord::Migration[5.0]
  def change
    create_table :terminal_gate_prices do |t|
      t.date :date
      
      t.float :diesel_sydney
      t.float :diesel_melbourne
      t.float :diesel_brisbane
      t.float :diesel_adelaide
      t.float :diesel_perth
      t.float :diesel_darwin
      t.float :diesel_hobart
      t.float :diesel_national_average
      
      t.float :petrol_sydney
      t.float :petrol_melbourne
      t.float :petrol_brisbane
      t.float :petrol_adelaide
      t.float :petrol_perth
      t.float :petrol_darwin
      t.float :petrol_hobart
      t.float :petrol_national_average

      t.timestamps
    end
  end
  
  def down
    destroy_table :terminal_gate_prices
  end
end

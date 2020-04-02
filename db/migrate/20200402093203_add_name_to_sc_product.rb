class AddNameToScProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :sc_products, :name, :string
  end
end

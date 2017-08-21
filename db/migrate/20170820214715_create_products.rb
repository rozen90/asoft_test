class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
    	t.string :category_name
    	t.text :content
      t.timestamps
    end
  end
end

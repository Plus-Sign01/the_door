class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
     
      t.timestamps

    end
    add_index :users, [:provider, :uid], unique: true
  end
end

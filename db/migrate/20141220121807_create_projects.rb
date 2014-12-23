class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :owner_id
      t.string :name,          null: false
      t.string :place,         null: false
      t.datetime :start_time,  null: false
      t.datetime :end_time,    null: false
      t.text :content,         null: false

      t.timestamps
    end
    add_index :projects, :owner_id
  end
end

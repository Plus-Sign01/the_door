class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.references :user, index: true
      t.references :project, index: true
      t.string :school
      t.string :language
      t.string :skill
      t.string :comment

      t.timestamps
    end
    add_index :participations, [:user_id, :project_id], unique: true

  end
end

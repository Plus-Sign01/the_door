class AddPasswordDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :age, :occupation, :password_digest, :string
  end
end

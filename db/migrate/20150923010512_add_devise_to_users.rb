class AddDeviseToUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false

      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      # Uncomment below if timestamps were not included in your original model.
      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
  end

  def self.down
    drop_table :users
  end
end

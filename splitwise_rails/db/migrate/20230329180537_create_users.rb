class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :user_name, null: false, index: true
      t.string :password_digest
      t.timestamps
    end
  end
end

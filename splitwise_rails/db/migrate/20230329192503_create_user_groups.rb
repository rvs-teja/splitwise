class CreateUserGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :user_groups, id: :uuid do |t|
      t.references :group, type: :uuid, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.index [:group_id, :user_id], unique: true
      t.timestamps
    end
  end
end

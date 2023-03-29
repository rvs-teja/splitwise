class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.string :creator_id, null: false, index: true
      t.index [:name, :creator_id]
      t.timestamps
    end
  end
end

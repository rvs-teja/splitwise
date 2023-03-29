class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.references :creator, type: :uuid, null: false, index: true
      t.index [:name, :creator_id], unique: true
      t.timestamps
    end
  end
end

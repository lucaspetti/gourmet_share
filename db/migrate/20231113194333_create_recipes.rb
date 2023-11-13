class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :title, null: false
      t.text :description, null: false
      t.text :ingredients, array: true, default: []
      t.text :preparation_steps, array: true, default: []

      t.timestamps
    end
  end
end

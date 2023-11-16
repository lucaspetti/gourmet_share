class CreateRecipeUploads < ActiveRecord::Migration[6.0]
  def change
    create_table :recipe_uploads, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.datetime :finished_at

      t.timestamps
    end
  end
end

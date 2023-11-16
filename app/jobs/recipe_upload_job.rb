class RecipeUploadJob < ApplicationJob
  queue_as :default

  def perform(recipe_upload_id)
    recipe_upload = RecipeUpload.find(recipe_upload_id)

    RecipeUploadService.run(recipe_upload.user_id, recipe_upload.file.download)
    recipe_upload.update!(finished_at: Time.zone.now)
  end
end

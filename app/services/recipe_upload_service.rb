class RecipeUploadService
  def initialize(user_id)
    @user = User.find(user_id)
  end

  def self.run(user_id, file)
    new(user_id).run(file)
  end

  def run(file)
    @csv = load_csv(file.force_encoding('UTF-8'))
    # TODO: validate headers

    @csv.map do |row|
      params = row.to_h.with_indifferent_access
      params[:ingredients] = row[:ingredients].split(';')
      params[:preparation_steps] = row[:preparation_steps].split(';')

      RecipeFactory.create(@user, params)
    end
  end

  def load_csv(file, encoding = nil, separator = ',')
    CSV.parse(file, headers: true, col_sep: separator)
  rescue CSV::MalformedCSVError
    false
  end
end

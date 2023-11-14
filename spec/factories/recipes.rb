FactoryBot.define do
  factory :recipe do
    user
    title { 'Spaghetti Bolognese' }
    description { 'A classic Italian dish with rich tomato sauce and ground beef.' }
    ingredients do
      [
        "500g ground beef",
        "400g spaghetti"
      ]
    end
    preparation_steps do
      [
        "Boil water and cook spaghetti according to package instructions.",
        "In a large pan, brown the ground beef over medium heat."
      ]
    end
  end
end

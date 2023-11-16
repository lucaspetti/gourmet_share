# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

user = User.find_by(email: 'max@mustermann.com')

if user.nil?
  user = User.create(email: 'max@mustermann.com', first_name: 'Max', last_name: 'Mustermann', password: 'S4f3P4ssword!')
end

recipe = {
  "user_id": user.id,
  "title": "Spaghetti Bolognese",
  "description": "A classic Italian dish with rich tomato sauce and ground beef.",
  "preparation_steps": [
    "Boil water and cook spaghetti according to package instructions.",
    "In a large pan, brown the ground beef over medium heat.",
    "Add chopped onions, garlic, and cook until onions are translucent.",
    "Stir in crushed tomatoes, tomato paste, and season with salt, pepper, and Italian herbs.",
    "Simmer for 20 minutes, allowing the flavors to meld.",
    "Serve the Bolognese sauce over the cooked spaghetti.",
    "Garnish with grated Parmesan cheese and fresh basil."
  ],
  "ingredients": [
    "500g ground beef",
    "400g spaghetti",
    "1 onion, chopped",
    "2 cloves garlic, minced",
    "1 can (400g) crushed tomatoes",
    "2 tablespoons tomato paste",
    "Salt and pepper to taste",
    "1 teaspoon dried Italian herbs",
    "Grated Parmesan cheese for garnish",
    "Fresh basil leaves for garnish"
  ]
}

Recipe.create(recipe)

Doorkeeper::Application.create(name: "Client App 1", redirect_uri: "urn:ietf:wg:oauth:2.0:oob", scopes: ["read", "write"])

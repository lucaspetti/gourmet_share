# README

* Ruby version: 2.6.3

* Rails version: 6.0.6.1

* Using Postgres Database

## Running the project

### Install dependencies

```bash
bundle install
```

### Setup the database and ENV variables

* Make sure to replace the appropriate env variables

```bash
cp .env.example .env
rails db:create db:migrate
```

Additionally, the DB can be seeded with

```bash
rails db:seed
```

### Running application

```bash
rails s
```

### Running tests

```bash
bundle exec rspec
```

### Running with Docker

```bash
docker-compose up -d

# make sure to run migrations after containers are up
docker exec gourmet_share_web_1 bundle exec rails db:create db:migrate
```

### Using the API

#### Create Application to consume the API

Enter rails console and create it (not needed if DB was seeded as it is present on `db/seeds.rb`)

```bash
Doorkeeper::Application.create(
  name: "Client App 1",
  uid: "client_app_uid",
  secret: "client_app_secret",
  redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
  scopes: ["read", "write"]
)
```

#### Signup and login user to retrieve token

* To signup a user, you need to use the API credentials for a client application.
* Using the client_uid from the previously generated application, this is how a signup with a curl request would look like:

```bash
curl -d '{"client_id":"client_app_uid", "user": { "email": "max@muster.com", "first_name": "Max", "last_name": "Muster", "password": "S4f3P4ssw0rd!" }}' \
-H "Content-Type: application/json" \
-X POST http://localhost:3000/api/v1/auth/signup
```

* This is how a login request would look like:

```bash
curl -d '{"client_id":"client_app_uid", "user": { "email": "max@muster.com", "password": "S4f3P4ssw0rd!" }}' \
-H "Content-Type: application/json" \
-X POST http://localhost:3000/api/v1/auth/login
```

#### Endpoints

* After fetching the access token from signup or login, add it as an authorization header for further requests to the API.
* It should be added as `{ "Authorization": "Bearer ADD_TOKEN_HERE" }`.
* Requests without proper auth header will return a 401 response

```bash
# See user data
GET /api/v1/me

Returns the logged user data:
{
  "id":"d67437a6-4bbe-4ecf-b442-6c6492e35bde",
  "email":"max@muster.com",
  "first_name":"Max",
  "last_name":"Muster",
  "created_at":"2023-11-16T19:12:25.980Z",
  "updated_at":"2023-11-16T19:12:25.980Z"
}

# List recipes
GET /api/v1/recipes

Returns a list of recipes:
[
  {
    "id": "7d7a3624-473e-46df-b149-461c68146a70",
    "title": "Spaghetti Bolognese",
    "description": "A classic Italian dish with rich tomato sauce and ground beef.",
    "ingredients": ["500g ground beef","400g spaghetti", "other ingredients"],
    "preparation_steps": [
      "Boil water and cook spaghetti according to package instructions.",
      "In a large pan, brown the ground beef over medium heat.",
      "Add other ingredients",
      "Enjoy!"
      "Add chopped onions, garlic, and cook until onions are translucent.","Stir in crushed tomatoes, tomato paste, and season with salt, pepper, and Italian herbs.","Simmer for 20 minutes, allowing the flavors to meld.","Serve the Bolognese sauce over the cooked spaghetti.","Garnish with grated Parmesan cheese and fresh basil."
      ],
    "created_at": "2023-11-13T20:03:31.691Z",
    "author": "max@mustermann.com"
  },
  {
    "id": "496c6b61-aaed-4ee1-808f-4773437d4569",
    "title": "Spaghetti Bolognese","description":"A classic Italian dish with rich tomato sauce and ground beef.",
    "ingredients": ["500g ground beef","400g spaghetti"],
    "preparation_steps": ["Boil water and cook spaghetti according to package instructions."],
    "created_at": "2023-11-13T19:59:03.572Z",
    "author": "max@mustermann.com",
    "image_url": "http://localhost:3000/path/to/blobs/image/spaghetti.jpeg"
  }
]

# Create recipe
POST /api/v1/recipe

- Request params in JSON body:
{
  "recipe": {
    "title": "Spaghetti",
    "description": 'A nice dish',
    "ingredients": ["500g ground beef","400g spaghetti"],
    "preparation_steps": ["Boil water and cook spaghetti according to package instructions."]
  }
}

If successful, returns the created recipe in the response:
{
    "id": "496c6b61-aaed-4ee1-808f-4773437d4569",
    "title": "Spaghetti Bolognese","description":"A classic Italian dish with rich tomato sauce and ground beef.",
    "ingredients": ["500g ground beef","400g spaghetti"],
    "preparation_steps": ["Boil water and cook spaghetti according to package instructions."],
    "created_at": "2023-11-13T19:59:03.572Z",
    "author": "max@mustermann.com",
    "image_url": "http://localhost:3000/path/to/blobs/image/spaghetti.jpeg"
  }

If there is an error, it will return a 422 status code with the error message:
{ "error": "Could not create recipe" }

# Show recipe
GET /api/v1/recipes/RECIPE_ID

Returns a recipe:
{
    "id": "496c6b61-aaed-4ee1-808f-4773437d4569",
    "title": "Spaghetti Bolognese","description":"A classic Italian dish with rich tomato sauce and ground beef.",
    "ingredients": ["500g ground beef","400g spaghetti"],
    "preparation_steps": ["Boil water and cook spaghetti according to package instructions."],
    "created_at": "2023-11-13T19:59:03.572Z",
    "author": "max@mustermann.com",
    "image_url": "http://localhost:3000/path/to/blobs/image/spaghetti.jpeg"
  }

If the ID does not match an existing one, it will return a 404 status code with the error message:
{ "error": "Not found" }

# Create recipe upload
POST /api/v1/recipe_uploads

- Request params as multipart form:
"recipe_upload[file]=@/path/to/file.csv"

It returns the recipe upload data as JSON:
{
  "id":"0e04b72c-631d-463a-8f60-ec995c2c7c57",
  "user_id":"7d0ee8a7-a7e8-48bc-8c51-c226aa73b1af",
  "finished_at": null,
  "created_at":"2023-11-17T12:56:24.987Z",
  "updated_at":"2023-11-17T12:56:24.997Z"
}

If there is an error, it will return a 422 status code with the error message:
{ "error": "Could not create recipe upload" }
```

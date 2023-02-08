# POST /albums and POST /artists Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
   POST
  * the path
   /albums
  * any query parameters (passed in the URL)
   https://localhost:9292/albums
  * or body parameters (passed in the request body)
   title = 'Voyage'
   release_year = 2022
   artist_id = 2

   # Request:
GET /artists

# Expected response (200 OK)
Pixies, ABBA, Taylor Swift, Nina Simone

# Request 2:
POST /artists

# Expected response (200 OK)
(No content)


## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._

```html
<!-- EXAMPLE -->
<!-- Response when the post is found: 200 OK -->

<html>
  <head></head>
  <body>
    <h1>200 OK</h1>
    <div>Pixies, ABBA, Taylor Swift, Nina Simone</div>
  </body>
</html>
```

```html
<!-- EXAMPLE -->
<!-- Response when the post is not found: 404 Not Found -->

REQUEST 2 
<html>
  <head></head>
  <body>
    <h1>200 OK</h1>
    <div>Artist has been added</div>
  </body>
</html>
```


## 3. Write Examples

_Replace these with your own design._

```
# Request:

GET /artists

# Expected response:

Response for 200 OK
Pixies, ABBA, Taylor Swift, Nina Simone
```
```
# Request 2:

POST /artists

# Expected response:

Response for 200 OK
Artist has been added
```


## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "GET /artists" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to eq('Pixies, ABBA, Taylor Swift, Nina Simone')
    end

  end

  context "POST /artists" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post('/artists', name: 'Wild nothing', genre: 'Indie')

      expect(response.status).to eq(200)
      expect(response.body).to eq('Artist has been added')

      response_2 = get('/artists')

      expect(response_2.status).to eq(200)
      expect(response_2.body).to eq('Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing')
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->
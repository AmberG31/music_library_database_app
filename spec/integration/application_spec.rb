require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_artists_table
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do

  before(:each) do 
    reset_artists_table
    reset_albums_table
  end

  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /albums" do
    it 'should return all albums in HTML' do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include("<h1>Albums</h1>")
      expect(response.body).to include("Title: <a href ='/albums/2'>Surfer Rosa</a>")
      expect(response.body).to include("Released: 1988")
    end
  end

  context " GET /albums/:id" do
    it "returns info about one album" do
      response = get('/albums/1')

      expect(response.status).to eq (200)
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
      expect(response.body).to include('Artist: Pixies')
    end
  end

  context "POST to /albums/new" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post(
        "/albums/new", 
        title: "Voyage", 
        release_year: 2022, 
        artist_id: 2
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('New album is present in the list of records.')
    end

    it 'returns 404 Not Found' do
      response = get('/album?id=276278')

      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end
  end

  context "GET /artists" do
    it 'returns a list of artists in HTML page' do
      response = get('/artists')
      expect(response.status).to eq (200)
      expect(response.body).to include('<h1>Artists:</h1>')
      expect(response.body).to include('Pixies')
      # expect(response.body).to include('Genre: Rock')
    end
  end

  context "GET /artists/:id" do
    it "returns an album based on given id in HTML page" do
      response = get('/artists/1')

      expect(response.status).to eq (200)
      expect(response.body).to include('<h1>Artist:</h1>')
      expect(response.body).to include('Name: Pixies')
      expect(response.body).to include('Genre: Rock')
    end
  end

  context "POST /artists/new" do
    it 'returns 200 OK' do
      response = post('/artists/new', name: 'Wild nothing', genre: 'Indie')
      expect(response.status).to eq(200)
      expect(response.body).to eq('Artist has been added')

      response = get('/artists')
      expect(response.status).to eq(200)
      # expect(response.body).to eq('Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing')
    end
  end

end
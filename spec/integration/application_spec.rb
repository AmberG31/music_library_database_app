require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_artists_table
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do

  before(:each) do 
    reset_artists_table
  end

  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "POST to /albums" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post(
        "/albums", # was writen album
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
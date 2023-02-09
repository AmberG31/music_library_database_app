require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    albums = repo.all

    response = albums.map{ |album| album.title }.join(", ")
  end

  post '/albums' do # /:title/:release_year/:artist_id -> it said album
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo = AlbumRepository.new
    repo.create(new_album)
    
    body = "New album is present in the list of records."
    return body
  end

  get '/artists' do
    repo = ArtistRepository.new
    artists = repo.all
    names = []
    artists.each do |artist|
      names << artist.name
    end
    return names.join(', ')
  end

  post '/artists' do
    repo = ArtistRepository.new
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    repo.create(artist)
    return 'Artist has been added'
  end

end
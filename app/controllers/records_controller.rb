class RecordsController < ApplicationController

  def index
    response = HTTParty.get('https://1.ravenhq.com/docs')
    response = HTTParty.get(response.headers['oauth-source'], :headers => { "Api-Key" => "c80aa865-da7d-4c16-8444-ee09e693e9c3"})
    auth = "Bearer " + response.body
    response = HTTParty.get('https://1.ravenhq.com/databases/benfulton-SourcedTriples/docs/?start=0&pageSize=10', :headers => { "Authorization" => auth })
    @json = response.body
    parsed_json = ActiveSupport::JSON.decode(@json)
  end
end
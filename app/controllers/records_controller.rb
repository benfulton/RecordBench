class RecordsController < ApplicationController

  def index
    response = HTTParty.get('https://1.ravenhq.com/docs')
    response = HTTParty.get(response.headers['oauth-source'], :headers => { "Api-Key" => key})
    auth = "Bearer " + response.body
    response = HTTParty.get('https://1.ravenhq.com/databases/benfulton-SourcedTriples/docs/?start=0&pageSize=10', :headers => { "Authorization" => auth })
    @json = response.body
    parsed_json = ActiveSupport::JSON.decode(@json)
  end
end

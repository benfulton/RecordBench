class RecordsController < ApplicationController

  def index
    loadDocs()
    @docs = JSON.parse(Rails.cache.read('docs')).reject{|doc|doc["Source"].nil?}

  end
  
  def show
     loadDocs()
     @doc = JSON.parse(Rails.cache.read('docs')).find{|doc|doc["@metadata"]["@id"] == params[:id]}
  end
  
  def loadDocs
    if !Rails.cache.exist?('docs')
      response = HTTParty.get('https://1.ravenhq.com/docs')
      response = HTTParty.get(response.headers['oauth-source'], :headers => { "Api-Key" => APIKEY})
      auth = "Bearer " + response.body
      response = HTTParty.get('https://1.ravenhq.com/databases/benfulton-SourcedTriples/docs/?start=0&pageSize=10', :headers => { "Authorization" => auth })
      Rails.cache.write('docs', response.body)
    end
  end

end

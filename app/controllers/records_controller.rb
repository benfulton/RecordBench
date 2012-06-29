class RecordsController < ApplicationController

  before_filter :loadDocs

  def doc_list
    JSON.parse(Rails.cache.read('docs'))
  end
  
  def index
    @docs = doc_list.reject{|doc|doc["Source"].nil?}
  end
  
  def show
     @doc = find(params[:id])
  end
  
  def edit
     @doc = find(params[:id])
  end

  def update
     @doc = find(params[:id])
     flash.now[:notice] = 'Record updated.'
     render :action => "show"
  end

  def find(id)
    doc_list.find{|doc|doc["@metadata"]["@id"] == id}
  end
  
  def loadDocs
    if !Rails.cache.exist?('docs')
      response = HTTParty.get('https://1.ravenhq.com/docs')
      response = HTTParty.get(response.headers['oauth-source'], :headers => { "Api-Key" => ENV['RAVEN_KEY']})
      auth = "Bearer " + response.body
      response = HTTParty.get( ENV['RAVEN_DB'] + '/docs/?start=0&pageSize=10', :headers => { "Authorization" => auth })
      Rails.cache.write('docs', response.body)
    end
  end

end

class RecordsController < ApplicationController

  def index
    loadDocs()
    @docs = JSON.parse(Rails.cache.read('docs')).reject{|doc|doc["Source"].nil?}

  end
  
  def show
     loadDocs()
     @doc = JSON.parse(Rails.cache.read('docs')).find{|doc|doc["@metadata"]["@id"] == params[:id]}
  end
  
  def edit
     loadDocs()
     @doc = JSON.parse(Rails.cache.read('docs')).find{|doc|doc["@metadata"]["@id"] == params[:id]}
  end

  def update
     loadDocs()
     @doc = JSON.parse(Rails.cache.read('docs')).find{|doc|doc["@metadata"]["@id"] == params[:id]}
      flash.now[:notice] = 'Record updated.'
     #redirect_to :action => 'show', :id => params[:id]
     render :action => "show"
  end

  def loadDocs
    if !Rails.cache.exist?('docs')
      response = HTTParty.get('https://1.ravenhq.com/docs')
      response = HTTParty.get(response.headers['oauth-source'], :headers => { "Api-Key" => 'c80aa865-da7d-4c16-8444-ee09e693e9c3'})
      auth = "Bearer " + response.body
      response = HTTParty.get('https://1.ravenhq.com/databases/benfulton-SourcedTriples/docs/?start=0&pageSize=10', :headers => { "Authorization" => auth })
      Rails.cache.write('docs', response.body)
    end
  end

end

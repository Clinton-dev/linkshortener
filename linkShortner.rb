require 'sinatra'
require 'base64'
require 'pstore'

#TO DOS
# add form to page
# add list of all urls in db
#check for duplicates

get '/:url' do 
   original = ShortUrl.read(params[:url])

   if original
    redirect "http://" + original
   else
    "Sorry your URL cannot be found"
   end
end

get '/' do 
  "Enter your URL using a curl POST request"
end

post '/' do
    url = generate_short_url(params[:url])
    "Your shortened URL is: #{url}\n "
end

def generate_short_url(original)
  ShortUrl.save(Base64.encode64(original)[0..6],original)

  "localhost:4567/" + Base64.encode64(original)[0..6]
end

class ShortUrl
   def self.save(encoded, original)
     store.transaction { |t| store[encoded] = original}
   end

   def self.read(encoded)
     store.transaction{ store[encoded] }
   end

   def self.store
     @store ||= PStore.new("shortened_urls.db")
   end
end

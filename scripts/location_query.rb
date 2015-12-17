require 'json'
require 'uri'

GMapKey = 'AIzaSyCKSPHhVUQ8DPAH88FtQ47_WzlovvvfaVI'

def curl(url)
  `curl #{url}`
=begin
  puts 'query url: ', url
  output = `curl #{url}`
  puts output

  output
=end
end

def location_query(place_id)
  url = "https://maps.googleapis.com/maps/api/place/details/json\\?placeid\\=#{place_id}\\&key\\=#{GMapKey}"
  output = curl(url)
  JSON.parse(output)['result']['geometry']['location']
end

# geocode shoould be a string (of 6 digits)
def place_id_query(geocode)
  # url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json\\?key=#{GMapKey}\\&query\\=#{geocode}"
  url = "https://maps.googleapis.com/maps/api/place/autocomplete/json\\?key\\=#{GMapKey}\\&input\\=#{geocode}"
  output = curl(url)

  JSON.parse(output)['predictions'][0]['place_id']
end

def query_based_on_postal_code(postal_code)
  geocode_str = '%06d' % postal_code
  location_query(place_id_query geocode_str)
end

obj = JSON.parse(File.read 'clenaed_clinics.json')

obj.each do |o|
  o['location'] = begin
                    query_based_on_postal_code o['postal']
                  rescue Exception => e
                    {}
                  end
end

puts JSON.pretty_generate(obj)

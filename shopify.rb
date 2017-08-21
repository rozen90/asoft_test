require 'nokogiri'
require 'curb'
require 'uri'
require 'json'

class Crawler

	def initialize()
		@url = "https://apps.shopify.com/"
		http = Curl.get(@url).body_str
		@node = Nokogiri::HTML(http)
	end

	def get_carusel
		result = {}
		mass = []
		carusel = @node.xpath("//div[@class='slideshow col12']/ul[@class='slideshow-selectors']//a")
		carusel.each_with_index do |val,index|
			content = {}
			label = JSON(val.xpath("./@data-track-click").text)['label']
			url = URI.join(@url,val.xpath("./@href").text).to_s
			content['label'] = label
			content['url'] = url
			content['position'] = index + 1
			content['cat_name'] = "Carusel"
			result['Carusel'] = mass.push(content)
		end
		return result.to_json.to_s
	end

	def get_others_cat
		result = {}
		products = []
		unic = []
		position = 0
		categories = @node.xpath("//div[@id='feature-groups']/div[@class='feature-group']//li[@itemtype='http://schema.org/Product' or contains(@class,'__item')]")
		categories.each do |val|
			start_position = 1
			content = {}
			content['cat_name'] = val.xpath("./a/@data-source").text
			content['url'] = URI.join(@url,val.xpath("./a/@href").text).to_s
			content['label'] = JSON(val.xpath("./a/@data-track-click").text)['label']
			content['position'] = unic.include?(content['cat_name']) ? position = position + 1 : (unic.push(content['cat_name']); position = start_position)
			products.push(content)
		end
		return products.group_by {|i| i['cat_name']}
	end

end

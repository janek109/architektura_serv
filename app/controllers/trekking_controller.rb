require 'rubygems'
require 'json'
require 'net/http'
require 'uri'

class TrekkingController < ApplicationController

	ELEVATION_BASE_URL = 'http://maps.googleapis.com/maps/api/elevation/json'
	CHART_BASE_URL = 'http://chart.apis.google.com/chart'

	#action
	def index
		lat = {};
		lng = {};
		lat[0] = params[:lata];
		lat[1] = params[:latb];
		lng[0] = params[:lnga];
		lng[1] = params[:lngb];

		if lat[0].to_i > 90 || lat[0].to_i < -90 || lat[0].to_s == ''
			lat[0] = "36.578581"
		end
	       	if lat[1].to_i > 90 || lat[1].to_i < -90 || lat[1].to_s == ''
			lat[1] = "36.23998"
		end

		if lng[0].to_i > 180 || lng[0].to_i < -180 || lng[0].to_s == ''
			lng[0] = "-118.291994"
		end

		if lng[1].to_i > 180 || lng[1].to_i < -180 || lng[1].to_s == ''
			lng[1] = "-116.83171"
		end
		
		path = lat[0]+","+lng[0]+"|"+lat[1]+","+lng[1];
		@path = path;
		
		view_context.getElevation path
		@lat = lat
		@lng = lng
		if params[:zoom].to_s == ''
			params[:zoom] = 3
		end
		@zoom = params[:zoom].to_s
		@title = "Elevation in straight line"

		size = {}
		size['width'] = 640
		size['height'] = 410

		@size = size

		isset = params[:isset]
		if isset.to_s == 't'
		Mapa.create(:url => view_context.getMap(lat,lng,@zoom,$center,size) , :url_link => "&lata="+ lat[0] +"&lnga="+ lng[0] +"&latb="+ lat[1] +"&lngb="+ lng[1] +"&zoom="+ @zoom +"")
		end

		@mapy = Mapa.order("created_at DESC").limit(5)
		#@mapy = Mapa.limit(5)
	end
	
end

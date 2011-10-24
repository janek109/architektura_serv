require 'rubygems'
require 'json'
require 'net/http'
require 'uri'

class ElevationController < ApplicationController

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

		if lat[0].to_s == '' || lat[1].to_s == '' || lng[0].to_s == '' || lng[1].to_s == ''
			lat = ["36.578581","36.23998"]
			lng = ["-118.291994","-116.83171"]
		end
		
		@path = lat[0]+","+lng[0]+"|"+lat[1]+","+lng[1];
		
		#getElevation path;
		@lat = lat
		@lng = lng
		@title = "Elevation in straight line"
	end
	
end

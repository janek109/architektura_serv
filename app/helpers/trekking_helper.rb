require 'rubygems'
require 'json'
require 'net/http'
require 'uri'

module TrekkingHelper
	ELEVATION_BASE_URL = 'http://maps.googleapis.com/maps/api/elevation/json'
	CHART_BASE_URL = 'http://chart.apis.google.com/chart'

	$center

	def getChart(chartData, chartDataScaling="-1000,6000", chartType="lc",chartLabel="",chartSize="640x160",chartColor="orange")

		chart_args = {
			'cht' => chartType,
			'chs' => chartSize,
			'chl' => chartLabel,
			'chco' => chartColor,
			'chds' => chartDataScaling,
			'chxt' => 'x,y',
			'chxr' => '1,' + chartDataScaling
		};

		dataString = "";

		for x in chartData
			dataString += x.to_s[0...-2] + ',';
		end
		dataString = 't:'+dataString
		dataString = dataString[0...-1];
		chart_args['chd'] = dataString.to_s;

		@chartUrl = CHART_BASE_URL + '?chxt=' + CGI.escape(chart_args['chxt']) + '&chds=' + CGI.escape(chart_args['chds']) + '&chs=' + CGI.escape(chart_args['chs']) + '&cht=' + CGI.escape(chart_args['cht']) + '&chxr=' + CGI.escape(chart_args['chxr']) + '&chd=' + CGI.escape(chart_args['chd']) + '&chco=' + CGI.escape(chart_args['chco']) + '&chl=' + CGI.escape(chart_args['chl']);


	end

	def getMinMaxHeight(arrayOfElevation)
		result = {}
		result[0] = arrayOfElevation[0]
		result[1] = arrayOfElevation[0]
		for data in arrayOfElevation
			if result[0] > data
				result[0] = data
			end

			if result[1] < data
				result[1] = data
			end
		end

		@resultToView = result
		getChart(chartData=arrayOfElevation,chartDataScaling=((result[0]-1000).to_s+','+(result[1]+1000).to_s))
	end

	def getElevation(path="36.578581,-118.291994|36.23998,-116.83171",samples="100",sensor="false")

		elvtn_args = {
			'path' => path,
			'samples' => samples,
			'sensor' => sensor
		}

		url = ELEVATION_BASE_URL + '?path='+CGI.escape(elvtn_args['path'])+'&samples='+CGI.escape(elvtn_args['samples'])+'&sensor='+CGI.escape(elvtn_args['sensor']);

		resp = Net::HTTP.get_response(URI.parse(url))
		data = resp.body
		response = JSON.parse(data)

		elevationArray = Array.new
		locationArray = Array.new

		for resultset in response['results']
			elevationArray << resultset['elevation']
		end

		for resultset in response['results']
			locationArray << resultset['location']
		end

		$center = response['results'][50]['location']
		@center = $center

		@elevationArrayToView = elevationArray

		getMinMaxHeight(arrayOfElevation=elevationArray)
	end

	def getMap(lat,lng,zoom,center,size)
		@mapUrl = 'http://maps.googleapis.com/maps/api/staticmap?center=' + center['lat'].to_s + ',' + center['lng'].to_s + '&path=color:red|weight:3|' + lat[0] + ',' + lng[0] + '|' + lat[1] + ',' + lng[1] + '&zoom=' + zoom + '&size=' + size['width'].to_s + 'x' + size['height'].to_s + '&maptype=roadmap&markers=color:red%7Ccolor:red%7Clabel:A%7C' + lat[0] + CGI.escape(',') + lng[0] + '&markers=color:red%7Ccolor:red%7Clabel:B%7C' + lat[1] + ',' + lng[1] + '&sensor=false';
	end

	def getLenOfRoad
	end

end

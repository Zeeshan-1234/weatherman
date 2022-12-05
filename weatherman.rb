#!/usr/bin/ruby
require 'csv'

if ARGV.length < 3
  puts "Too few arguments,\nShould be `ruby weatherman.rb -e 2002 /path/to/filesFolder`"
  exit
end

$months = ["January","February","March","April","May","June","July",
            "August","September","October","November","December"]
def first (date, path)
	puts "-e was called with #{date} and #{path}"

	temp_max = 0
	max_day = ""
	temp_min = 100
	min_day = ""
	humidity = 0
	hum_max_day = ""
	files = Dir["#{path}/*#{date}*.txt"]
	files.each do |file|
		table = CSV.parse(File.read(file)[2..], headers: true)

		for i in 0..table.length-2
			temp = table[i]["Max TemperatureC"]
			if  temp.to_i > temp_max
				temp_max = temp.to_i
				max_day = table[i][0]
			end
			
			temp = table[i]["Min TemperatureC"]
			if  temp.to_i < temp_min
				temp_min = temp.to_i
				min_day = table[i][0]
			end

			humid = table[i]["Max Humidity"]
			if  humid.to_i > humidity
				humidity = humid.to_i
				hum_max_day = table[i][0]
			end
		end
	end
	month = max_day.split('-')[1].to_i
	day = max_day.split('-')[2]
	puts "Highest: #{temp_max}C on #{$months[month-1]} #{day}"

	month = min_day.split('-')[1].to_i
	day = min_day.split('-')[2]
	puts "Lowest: #{temp_min}C on #{$months[month-1]} #{day}"

	month = hum_max_day.split('-')[1].to_i
	day = hum_max_day.split('-')[2]
	puts "Humid: #{humidity}\% on #{$months[month-1]} #{day}"
end

def second (date, path)
	puts "-a was called"
end

def third (date, path)
	puts "-c was called"
end

case ARGV[0]
when '-e'
	first ARGV[1], ARGV[2]
when '-a'
	second ARGV[1], ARGV[2]
when '-c'
	third ARGV[1], ARGV[2]
else
	puts "incorrect argument, choose between `-e`,`-a`,`-c`"
end

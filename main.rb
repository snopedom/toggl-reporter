require 'togglv8'
require 'date'
require 'time'
require 'csv'

COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
ZONE = DateTime.now.zone

def days_in_month(month, year = Time.now.year)
   return 29 if month == 2 && Date.gregorian_leap?(year)
   COMMON_YEAR_DAYS_IN_MONTH[month]
end

def print_day_hour_sum(token, project_id, month, year = Time.now.year)
	toggl = TogglV8::API.new(token)

	month_days = days_in_month(month, year)

	start_date = DateTime.new(year,month,1,0,0,0, ZONE)
	end_date = DateTime.new(year,month,month_days,23,59,59, ZONE)

	dates = {
		start_date: start_date,
		end_date: end_date
	}

	entries = toggl.get_time_entries(dates)

	project_entries = []
	entries.each do |entry|
		if entry['pid'] == project_id
			project_entries << entry
		end
	end

	user_info = toggl.me

	day_hours_data = {
		days: [*1..month_days],
		data: [],
		user_name: user_info['fullname'],
		user_email: user_info['email']
	}

	month_days.times  do |day|
		day_hours_sum = 0.0
		current_day = day+1
		project_entries.each do |project_entry|
			unless project_entry['stop'].nil?
				start = Time.iso8601(project_entry['start'])

				day_start = Time.new(year, month, current_day, 0, 0, 0, ZONE)
				day_end = Time.new(year, month, current_day, 23, 59, 59, ZONE)

				if start >= day_start && start <= day_end
					day_hours_sum += project_entry['duration']/60.0/60.0
				end

			end
		end
		day_hours_data[:data] << {
						day: current_day,
						hours: day_hours_sum.round(2)
					}
	end
	return day_hours_data
end

args = Hash[ ARGV.join(' ').scan(/--?([^=\s]+)(?:=(\S+))?/) ]

token = ''
project_id = 0
month = 0
year = 0

unless args['token'].nil?
	token = args['token'].to_s
else
	raise Exception.new("TOKEN argument must be provided!")
end

unless args['project_id'].nil?
	project_id = args['project_id'].to_i
else
	raise Exception.new("PROJECT ID argument must be provided!")
end

unless args['month'].nil?
	month = args['month'].to_i
else
	raise Exception.new("MONTH argument must be provided!")
end

unless args['year'].nil?
	year = args['year'].to_i
else
	raise Exception.new("YEAR argument must be provided!")
end

month_data = print_day_hour_sum(token, project_id, month, year)

csv_header = month_data[:days]
csv_data = []
month_data[:data].each do |day_data|
	csv_data << day_data[:hours]
end

CSV.open("#{month_data[:user_name]}_#{month_data[:user_email]}_day_report_#{month}.csv", "w") do |csv|
  csv << csv_header
  csv << csv_data 
end

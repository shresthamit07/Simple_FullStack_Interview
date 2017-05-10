require 'sinatra'

get '/' do
	erb :index
end

post '/' do
	if(params[:file_upload].nil?)
		@error_msg = "Invalid File."
	else
		@filename = params[:file_upload][:filename]
		if(File.extname(@filename) == ".txt")
			contents = params[:file_upload][:tempfile].readlines
			if !contents.empty?
				@user_detail = prepare_user_data(contents)
				@total_count = @user_detail.size
			end
		else
			@error_msg = "Only .txt files are allowed"
		end

	end
	erb :index
end

public
def prepare_user_data(file_contents)
	first_line = file_contents.first.strip
	
	user_hash = if first_line.split(',').size > 1
		user_attributes = ['LastName', 'FirstName', 'Pet', 'FavoriteColor', 'DateOfBirth', 'MiddleInitial']
		handle_delimeted_file(file_contents, delimeter=',', user_attributes)
	elsif first_line.split(' ').size > 1
		user_attributes = ['LastName', 'FirstName', 'MiddleInitial', 'Pet', 'DateOfBirth', 'FavoriteColor']
		handle_delimeted_file(file_contents, delimeter=' ', user_attributes)
	elsif first_line.split('|').size > 1
		user_attributes = ['LastName', 'FirstName', 'MiddleInitial', 'Pet', 'FavoriteColor', 'DateOfBirth']
		handle_delimeted_file(file_contents, delimeter='|', user_attributes)
	else
		{}
	end

	return user_hash
end

def handle_delimeted_file(file_contents, delimeter, user_attributes)
	user_attr_array = []

	file_contents.each do |line|
		data_values = line.to_s.strip.split(delimeter)
		user_attr_array << user_attributes.each_with_index.inject({}) {|new_hash, (key, index)| new_hash[key] = (data_values[index] || ''); new_hash}
	end

	user_attr_array
end

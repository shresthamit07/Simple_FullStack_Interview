ENV['RACK_ENV'] = 'test'

require 'rack/test'
require_relative '../app.rb'

describe 'Wistia' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'when user visits the home page' do
    it 'should have import option' do
  	 get '/'

		  expect(last_response.body).to include("Import a File")
    end
	end

  context 'when user uploads invalid files (files other than mentioned in the requirements)' do
    it 'should list display 0 as user count in the page' do
      invalid_file = './public/invalid_file.txt'
      post "/", "file_upload" => Rack::Test::UploadedFile.new(invalid_file, "text/txt")
      
      expect(last_response.body).to include("0   People")
    end
  end

  context 'when user uploads proper comma separated txt file with user infos' do
    it 'should display the user count in the page' do
      comma_separate_file = './public/comma.txt'
      post "/", "file_upload" => Rack::Test::UploadedFile.new(comma_separate_file, "text/txt")

      expect(last_response.body).to include("3   People")
    end
  end

  context 'when user uploads proper space separated txt file with user infos' do
    it 'should display the user count in the page' do
      comma_separate_file = './public/space.txt'
      post "/", "file_upload" => Rack::Test::UploadedFile.new(comma_separate_file, "text/txt")

      expect(last_response.body).to include("3   People")
    end
  end

  context 'when user uploads proper pipe separated txt file with user infos' do
    it 'should display the user count in the page' do
      comma_separate_file = './public/pipe.txt'
      post "/", "file_upload" => Rack::Test::UploadedFile.new(comma_separate_file, "text/txt")

      expect(last_response.body).to include("3   People")
    end
  end

  describe 'prepare_user_data(params)' do

		subject { app.prepare_user_data(params) }

    context 'when the input is not either comma separated or space separated or pipe separated' do

      let(:params) {  ['amitshresthaME5/9/2017Blue'] }

      it 'should not call handle_delimeted_file' do
        expect(subject).to_not receive(:handle_delimeted_file).with(params)
      end
    end

    context 'when the input is either comma separated file' do

      let(:params) {  ['amit,shrestha,M,E,5/9/2017,Blue']  }

      it 'should call handle_delimeted_file' do
      		generic_test = double("Some Collaborator")
    			expect(generic_test).to receive(:handle_delimeted_file)
    			generic_test.prepare_user_data(params)
      end
    end

    context 'when the input is either space separated file' do

      let(:params) {  ['amit shrestha M E 5/9/2017 Blue']  }

      it 'should call handle_delimeted_file' do
        generic_test = double("Some Collaborator")
    		expect(generic_test).to receive(:handle_delimeted_file)
    		generic_test.prepare_user_data(params)
      end
    end

    context 'when the input is either pipe separated file' do

      let(:params) {  ['amit|shrestha|M|E|5/9/2017|Blue']  }

      it 'should call handle_delimeted_file' do
      	generic_test = double("Some Collaborator")
    		expect(generic_test).to receive(:handle_delimeted_file)
    		generic_test.prepare_user_data(params)
      end
    end

  end

  describe 'handle_delimeted_file(param1, param2, param3)' do

    subject { app.handle_delimeted_file(param1, param2, param3) }

    context 'when the input is either comma separated array' do

      let(:param1) {  ['shrestha,amit,M,Blue,5/9/2017']  }
      let(:param2) {  ','  }
      let(:param3) {  ['LastName', 'FirstName', 'Pet', 'FavoriteColor', 'DateOfBirth', 'MiddleInitial'] }

      it 'should return proper array of hash' do
        expect(subject).to eql(
          [{"LastName"=>"shrestha", "FirstName"=>"amit", "Pet"=>"M", "FavoriteColor"=>"Blue", "DateOfBirth"=>"5/9/2017", "MiddleInitial"=>""}]
          )
      end
    end

    context 'when the input is either space separated file' do

      let(:param1) {  ['shrestha,amit,M,D,5/9/2017,Blue']  }
      let(:param2) {   ' ' }
      let(:param3) {  ['LastName', 'FirstName', 'MiddleInitial', 'Pet', 'DateOfBirth', 'FavoriteColor']  }

      it 'should return proper array of hash' do
        expect(subject).to eql(
          [{"LastName"=>"shrestha,amit,M,D,5/9/2017,Blue", "FirstName"=>"", "MiddleInitial"=>"", "Pet"=>"", "DateOfBirth"=>"", "FavoriteColor"=>""}]
          )
      end
    end

    context 'when the input is either pipe separated file' do

      let(:param1) {  ['shrestha,amit,M,D,Blue, 5/9/2017']  }
      let(:param2) {   ' ' }
      let(:param3) {  ['LastName', 'FirstName', 'MiddleInitial', 'Pet', 'FavoriteColor', 'DateOfBirth']  }

      it 'should return proper array of hash' do
        expect(subject).to eql(
          [{"LastName"=>"shrestha,amit,M,D,Blue,", "FirstName"=>"5/9/2017", "MiddleInitial"=>"", "Pet"=>"", "FavoriteColor"=>"", "DateOfBirth"=>""}]
          )
      end
    end

  end

end
class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  Time.zone = 'Europe/Bucharest'
end

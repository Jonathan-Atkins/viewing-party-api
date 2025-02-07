class Api::V1::ViewingPartiesController < ApplicationController
  def create   
    require 'pry'; binding.pry
    required_params = [:name, :start_time, :end_time, :movie_id, :movie_title, :invitees]
    missing_params  = required_params.select { |param| params[param].blank? }
  end
end

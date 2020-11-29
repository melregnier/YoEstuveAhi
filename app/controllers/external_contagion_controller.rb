class ExternalContagionController < ApplicationController
  def create
    Users::InformInternalUsersOfPossibleRisk.new(mapped_user_location_histories).perform

    render head :ok
  end

  private

  def mapped_user_location_histories
    user_location_histories = params[:stays].map do | stay |
      location = Location.find_by(external_id: stay[:location_id], server_id: stay[:server_id])
      return nil if location.nil?

      {
        location_id: location.id,
        check_in: stay[:begin],
        check_out: stay[:end]
      }
    end
    user_location_histories.compact
  end
end
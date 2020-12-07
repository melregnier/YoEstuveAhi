class ExternalContagionController < ApplicationController
  def create
    Users::InformInternalUsersOfPossibleRisk.new(mapped_user_location_histories).perform

    head :ok
  end

  private

  def mapped_user_location_histories
    user_location_histories = params[:stays].map do | stay |
      Mappers::Mapper.new(stay, from: :stay, to: :user_location_history).perform
    end
    user_location_histories.compact
  end
end
module Users
  class InformInternalUsersOfPossibleRisk
    MINUTES_EXPOSED_TO_BE_AT_RISK = Rails.application.secrets.minutes_exposed_to_be_at_risk

    def initialize(user_location_histories)
      @user_location_histories = user_location_histories
    end

    def perform
      users_to_inform(@user_location_histories).each do |user|
        user.put_at_risk
        Notifications::NotifyUserOfPossibleRisk.new(user).perform
      end
    end

    private

    def users_to_inform(user_location_histories)
      users_to_inform = Set.new      
      user_location_histories.each do | user_location |
        # we add users with overlapping user locations histories and/or user locations
        users_to_inform.merge(in_contact_user_location_histories(user_location).map(&:user))
        users_to_inform.merge(in_contact_user_locations(user_location).map(&:user))
      end

      users_to_inform
    end

    def in_contact_user_location_histories(user_location)
      # obtain histories of user overlapping for more than X MINUTES with the particular sick user location
      user_location_histories = overlapping_user_location_histories(user_location).select do | overlapping_user_location |
        MINUTES_EXPOSED_TO_BE_AT_RISK <= contact_time_with_user_location_history(user_location, overlapping_user_location).minutes
      end

      # we filter those who took a negative test after the contact and those already infected
      user_location_histories.reject do | user_location_history |
        user_location_history.user.infected? || has_been_tested_negative_since?(user_location_history)
      end
    end

    def in_contact_user_locations(user_location)
      # obtain user locations of user overlapping for more than X MINUTES with the particular sick user location
      user_locations = overlapping_user_locations(user_location).select do | overlapping_user_location |
        MINUTES_EXPOSED_TO_BE_AT_RISK <= contact_time_with_user_location(user_location, overlapping_user_location).minutes
      end

      # we filter those who took a negative test after the contact and those already infected
      user_locations.reject do | user_location |
        user_location.user.infected? || has_been_tested_negative_since?(user_location)
      end
    end

    def overlapping_user_location_histories(user_location)
      UserLocationHistory.where(location_id: user_location[:location_id]).where(
        [
          overlapping_check_in_condition, 
          overlapping_check_out_condition, 
          overlapping_containing_condition
        ].join(' OR '),
        {check_in: user_location[:check_in], check_out: user_location[:check_out]})
    end

    def overlapping_user_locations(user_location)
      UserLocation.where(location_id: user_location[:location_id]).where(
        'check_in < :check_out',
        {check_out: user_location[:check_out]}
      )
    end

    def overlapping_check_in_condition
      '(check_in >= :check_in AND check_in <= :check_out)'
    end

    def overlapping_check_out_condition
      '(check_out >= :check_in AND check_out <= :check_out)'
    end

    def contact_time_with_user_location_history(user_location_fst, user_location_snd)
      [user_location_fst&.[](:check_out) || Time.zone.now, user_location_snd&.[](:check_out) || Time.zone.now].min -
      [user_location_fst[:check_in], user_location_snd[:check_in]].max
    end

    def contact_time_with_user_location(user_location_history, user_location)
      user_location_history[:check_out] -
      [user_location_history[:check_in], user_location[:check_in]].max
    end

    def overlapping_containing_condition
      '(check_in < :check_in AND check_out > :check_out)'
    end

    def has_been_tested_negative_since?(user_location_history)
      user_location_history.user.covid_tests.negative.where('date > :contact_date', { contact_date: user_location_history.check_in.to_date }).any?
    end
  end
end
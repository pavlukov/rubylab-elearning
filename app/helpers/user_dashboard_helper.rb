# frozen_string_literal: true

module UserDashboardHelper

  def id_for_selected_menu_user(active)
    case active
    when :dashboard
      'v-pills-dashboard-tab'
    when :profile
      'v-pills-profile-tab'
    when :participations
      'v-pills-courses-tab'
    when :requests
      'v-pills-requests-tab'
    when :invites
      'v-pills-invites-tab'
    when :certificates
      'v-pills-certificates-tab'
    when :messages
      'v-pills-messages-tab'
    else
      ''
    end
  end
end

module ApplicationHelper
  def login_page?
    controller_name == 'sessions' && action_name == 'new'
  end
end

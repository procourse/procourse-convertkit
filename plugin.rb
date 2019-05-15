# name: procourse-convertkit
# version: 1.0
# author: ProCourse
# url: https://github.com/procourse/procourse-convertkit

require 'uri'
require "faraday"

after_initialize do
  DiscourseEvent.on(:user_created) do |user|
    url = "https://api.convertkit.com/v3/forms/#{SiteSetting.procourse_convertkit_form_id}/subscribe"
    conn = Faraday.new(url)
    conn.params['api_key'] = SiteSetting.procourse_convertkit_api_key
    conn.params['email'] = user.email
    conn.params['first_name'] = user.name
    response = conn.post
  end
end

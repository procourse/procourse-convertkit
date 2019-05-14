# name: procourse-convertkit
# version: 1.0
# author: ProCourse
# url: https://github.com/procourse/procourse-convertkit

gem 'mime-types-data', '3.2019.0331'
gem 'mime-types', '3.2.2'
gem 'httparty', '0.16.4'
require 'uri'

after_initialize do
  DiscourseEvent.on(:user_created) do |user|
    url = "https://api.convertkit.com/v3/forms/#{SiteSetting.procourse_convertkit_form_id}/subscribe?api_key=#{SiteSetting.procourse_convertkit_api_key}&email=#{URI::encode(user.email)}&first_name=#{URI::encode(user.name)}"
    request_payload = {
        headers: {
          'Content-Type' => 'application/json'
        }
      }
    begin
      byebug
      response = HTTParty.send(:post, url, request_payload)
    rescue HTTParty::Error => e
      puts e.message
      byebug
    end
  end
end

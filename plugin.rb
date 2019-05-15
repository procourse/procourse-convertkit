# name: procourse-convertkit
# version: 1.0
# author: ProCourse
# url: https://github.com/procourse/procourse-convertkit

require 'uri'
require "faraday"
require 'json'

after_initialize do
  DiscourseEvent.on(:user_created) do |user|
    url = "https://api.convertkit.com/v3/forms/#{SiteSetting.procourse_convertkit_form_id}/subscribe"
    conn = Faraday.new(url)
    conn.params['api_key'] = SiteSetting.procourse_convertkit_api_key
    conn.params['email'] = user.email
    conn.params['first_name'] = user.name
    response = conn.post

    if SiteSetting.procourse_convertkit_add_group && SiteSetting.procourse_convertkit_group && SiteSetting.procourse_convertkit_tag
      body = JSON.parse(response.body)
      tag = SiteSetting.procourse_convertkit_tag
      subscriber_id = body["subscription"]["subscriber"]["id"]
      tag_url = "https://api.convertkit.com/v3/subscribers/#{subscriber_id}/tags"
      tag_conn = Faraday.new(url)
      tag_conn.params['api_key'] = SiteSetting.procourse_convertkit_api_key
      tag_response = tag_conn.get(tag_url)

      tag_body = JSON.parse(tag_response.body)
      tags = tag_body["tags"]

      for tag in tags
        if tag["name"] == SiteSetting.procourse_convertkit_tag
          group = Group.find_by(name: SiteSetting.procourse_convertkit_group)
          if group && user
            group.add(user)
            group.save
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

# name: discourse-remove-tags
# about: A plugin that removed tags when topics are closed, invisible or deleted
# version: 1.0.1
# authors: Acacia Bengo Ssembajjwe
# url: https://github.com/heartsupport/discourse-remove-tags
# required_version: 2.7.0

enabled_site_setting :plugin_name_enabled

after_initialize do
  DiscourseEvent.on(:topic_status_updated) do |topic, status, enabled|
    needs_support_tag = Tag.find_by(name: "Needs-Support")
    if needs_support_tag && topic.tags.include?(needs_support_tag)
      case status
      when "closed"
        topic.tags.delete needs_support_tag if topic.closed == true
      when "visible"
        topic.tags.delete needs_support_tag if topic.visible == false
      end
    end
  end
end

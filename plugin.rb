# frozen_string_literal: true

# name: discourse-remove-tags
# about: A plugin that removed tags when topics are closed, invisible or deleted
# version: 1.0.1
# authors: Acacia Bengo Ssembajjwe
# url: https://github.com/heartsupport/discourse-remove-tags
# required_version: 2.7.0

enabled_site_setting :plugin_name_enabled

after_initialize do
  class ::Topic
    after_update :update_tags

    def update_topic_tags
      # check if topic has tag needs support and either closed or visible has changed
      needs_support_tag = Tag.find_by(name: "Needs-Support")

      if needs_support_tag && self.tags.include?(needs_support_tag)
        if self.visible == false || self.closed == true
          self.tags.delete needs_support_tag
        end
      end
    end
  end
end

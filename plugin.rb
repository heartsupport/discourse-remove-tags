# frozen_string_literal: true

# name: discourse-plugin-name
# about: A plugin that removed tags when topics are closed, invisible or deleted
# version: 1.0.1
# authors: Acacia Bengo Ssembajjwe
# url: https://github.com/heartsupport/discourse-remove-tags
# required_version: 2.7.0

enabled_site_setting :plugin_name_enabled

after_initialize do
  class ::Topic
    before_save :update_topic_tags, if: :has_needs_support_tag?

    def update_topic_tags
      # check if topic has tag needs support and either closed or visible has changed
      needs_support_tag = Tag.find_or_create_by(name: "Needs-Support")
      if closed_changed? && self.visible == true
        self.tags.delete needs_support_tag
      end

      if visible_changed? && self.visible == false
        self.tags.delete needs_support_tag
      end
    end
  end

  def has_needs_support_tag?
    needs_support_tag = Tag.find_or_create_by(name: "Needs-Support")
    self.tags.include? (needs_support_tag)
  end
end

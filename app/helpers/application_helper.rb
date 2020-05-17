# frozen_string_literal: true

module ApplicationHelper
  def avatar_url(user)
    return user.profile_photo unless user.profile_photo.nil?

    gravatar_id = Digest::MD5.hexdigest(user.email).downcase
    "https://www.gravatar.com/avatar/#{gravatar_id}.jpg"
  end

  def full_title(page_title)
    base_title = 'Nature-Picture'
    if page_title.blank?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end
end

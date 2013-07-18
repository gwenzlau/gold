class Post < ActiveRecord::Base
  attr_accessible :content, :lat, :lng, :photo, :submitted_by
  mount_uploader :photo, PhotoUploader
end

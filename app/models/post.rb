class Post < ActiveRecord::Base
	COORDINATE_DELTA = 0.05

 
  mount_uploader :photo, PhotoUploader


  scope :nearby, lambda { |lat, lng|
  where("lat BETWEEN ? AND ?", lat - COORDINATE_DELTA, lat + COORDINATE_DELTA).
  where("lng BETWEEN ? AND ?", lng - COORDINATE_DELTA, lng + COORDINATE_DELTA).
  limit(64)
}

belongs_to :user

# def as_json(options = nil)
# 	{
# 		:content => self.content,
# 		:postid => self.id,
# 		#:user => submitted_by,
# 		:lat => self.lat,
# 		:lng => self.lng,
# 		:content => self.content,

# 		:photo_urls => {
# 			:original => self.photo.url,
# 			:thumb => self.photo.url(:thumb)
# 		},

# 		:created_at => self.created_at.iso8601
# 	}
#  end
end

collection @posts
attributes :id, :content, :lat, :lng, :photo, :submitted_by
child(:user) { attributes :email, :signature }
node(:read) { |post| post.read_by?(@user) }
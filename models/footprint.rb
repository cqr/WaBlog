class Footprint
  property :id, Serial
  property :body, Text
  property :created_at, DateTime
  property :overwritable, Boolean
  belongs_to :post
end

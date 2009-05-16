class Folksonomy
  property :id, Serial
  belongs_to :post
  belongs_to :tag
end

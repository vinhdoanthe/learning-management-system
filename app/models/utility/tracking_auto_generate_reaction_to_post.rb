class Utility::TrackingAutoGenerateReactionToPost
  include Mongoid::Document
  include Mongoid::Timestamps

  field :post_id, type: Integer
  field :generated_content, type: Hash
end

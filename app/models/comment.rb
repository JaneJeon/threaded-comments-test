class Comment < ApplicationRecord
  self.ignored_columns = %w(created_at updated_at path htap)
end

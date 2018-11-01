class Comment < ApplicationRecord
  default_scope { select([:id, :body, :parent_id, :path, :htap]) }

  belongs_to :parent, :class_name => 'Comment', optional: true
  has_many :children, :class_name => 'Comment', :foreign_key => 'parent_id'
end

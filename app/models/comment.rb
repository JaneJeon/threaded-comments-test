class Comment < ApplicationRecord
  default_scope { select([:id, :body, :parent_id, :path, :htap]) }

  belongs_to :parent, optional: true, :class_name => 'Comment', :foreign_key => 'parent_id'
  has_many :children, dependent: :destroy, :class_name => 'Comment', :foreign_key => 'parent_id'
end

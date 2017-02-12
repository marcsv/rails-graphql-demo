class Blog < ApplicationRecord
  belongs_to :author, class_name: :User, foreign_key: "user_id"
  has_many :posts, dependent: :destroy
end

class TextPost < ApplicationRecord
    has_one :post, as: :postable

    validates :title, presence: { message: "You should write a title." }
    validates :body, presence: { message: "You should tell the other monkes something." }
end

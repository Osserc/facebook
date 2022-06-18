class ImagePost < ApplicationRecord
    has_one :post, as: :postable
    has_one_attached :image

    validates :title, presence: { message: "You should write a title." }
    validates :image, attached: { message: "You should include a picture." }, size: { less_than: 10.megabytes, message: "Your picture exceeds 10 megabytes." }, content_type: [:png, :jpg, :jpeg]
end

class ImagePost < ApplicationRecord
    has_one :post, as: :postable
    has_one_attached :image

    validates :title, presence: true
    validates :image, attached: true, size: { less_than: 10.megabytes, message: "Your file exceeds 10 megabytes." }, content_type: [:png, :jpg, :jpeg]
end

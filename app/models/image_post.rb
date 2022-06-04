class ImagePost < ApplicationRecord
    has_one :post, as: :postable
    has_one_attached :image

    validates :title, :image, presence: true
end

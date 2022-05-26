class TextPost < ApplicationRecord
    has_one :post, as: :postable

    validates :title, :body, presence: true
end

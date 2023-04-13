class DeniedIp < ApplicationRecord
  validates :ip, presence: true
end

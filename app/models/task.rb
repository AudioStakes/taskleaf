class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate :validate_name_not_including_comma
  before_validation :set_nameless_name

  belongs_to :user

  scope :recent, -> { order(created_at: :desc)}

  # Ransackによる検索対象として許可するカラムを指定
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end

  # Ransackによる検索の条件に含める関連を指定。意図しない関連を含めないようにするため、空配列を返す。
  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

  def set_nameless_name
    self.name = '名前なし' if name.blank?
  end
end

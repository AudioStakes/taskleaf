class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validate :validate_name_not_including_comma
  before_validation :set_nameless_name

  belongs_to :user
  has_one_attached :image

  scope :recent, -> { order(created_at: :desc)}

  # Ransackによる検索対象として許可するカラムを指定
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end

  # Ransackによる検索の条件に含める関連を指定。意図しない関連を含めないようにするため、空配列を返す。
  def self.ransackable_associations(auth_object = nil)
    []
  end

  def self.csv_attributes
    ["name", "description", "created_at", "updated_at"]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task|
        csv << csv_attributes.map{ |attr| task.send(attr)}
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      task = new
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

  def set_nameless_name
    self.name = '名無し' if name.blank?
  end
end

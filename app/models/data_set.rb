class DataSet
  include ActiveModel::Validations
  attr_accessor :distributions, :publisher, :identifier, :title, :description, :keyword, :modified, :contactPoint, :mbox, :accessLevel, :accessLevelComment, :temporal, :spatial, :dataDictionary, :accrualPeriodicity

  validates_presence_of :accessLevelComment, :if => :private?
  validate :distributions_download_url, :if => :public?
  validates :keywords, keywords: true

  def initialize(attributes = {})
    @distributions = []
    attributes.each do |name, value|
      if value.present?
        send("#{name}=", value.force_encoding(Encoding::UTF_8).strip)
      end
    end
  end

  def private?
    ["privado", "restringido"].include? accessLevel
  end

  def public?
    ["público"].include? accessLevel || accessLevel.blank?
  end

  def keywords
    keyword.to_s.split(",").map(&:strip).reject{ |k| k.empty? }
  end

  def download_url?
    distributions.all? { |distribution| distribution.downloadURL.present? }
  end

  def distributions_count
    distributions.size
  end

  def distributions_download_url
    unless download_url?
      errors.add(:distributions)
    end
  end
end

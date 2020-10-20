class FromtoValidator
  include ActiveModel::Validations

  attr_reader :data
  

  validates :from, presence: true, numericality: true, length: { is: 10 }
  validates :to, presence: true, numericality: true, length: { is: 10 }

  def initialize(data)
    @data = data || {}
  end

  def read_attribute_for_validation(key)
    data[key]
  end
end
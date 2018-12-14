class Book < ApplicationRecord
  

  validates :title, presence: true
  belongs_to :author
  accepts_nested_attributes_for :author
  belongs_to :publisher
  accepts_nested_attributes_for :publisher
  belongs_to :category
  accepts_nested_attributes_for :category
  has_many :reviews
  has_attached_file :book_img, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
    validates_attachment_content_type :book_img, content_type: /\Aimage\/.*\z/
    has_many :passive_relationships, class_name:  "Relationship",
             foreign_key: "followed_id",
             dependent:   :destroy
    has_many :followers, through: :passive_relationships, source: :follower

    def author_attributes=(attributes)
      self.author = Author.find_or_create_by(author_name: attributes[:author_name])
    end
    def category_attributes=(attributes)
      self.category = Category.find_or_create_by(category_name: attributes[:category_name])
    end
    def publisher_attributes=(attributes)
      self.publisher = Publisher.find_or_create_by(publisher_name: attributes[:publisher_name])
    end
    def self.search(search)
  # Title is for the above case, the OP incorrectly had 'name'
   joins(:category,:publisher,:author).where('category_name like ? or publisher_name like ? or author_name like ? or title like ?', "%#{search}%","%#{search}%","%#{search}%","%#{search}%")
  end
  def self.to_csv(a)
    CSV.generate do |csv|
    csv << column_names
      all.each do |book|
      csv << book.attributes.values_at(*column_names)
      end
  end
  end
     
end   

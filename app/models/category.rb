class Category < ApplicationRecord

	has_many :books, dependent:   :destroy
	validates :category_name, presence: true, length: {maximum: 50 }
	def self.search(search)
  # Title is for the above case, the OP incorrectly had 'name'
 	 where("category_name LIKE ?", "%#{search}%")
	end
	def self.to_csv(a)
		CSV.generate do |csv|
		csv << column_names
    	all.each do |category|
     	csv << category.attributes.values_at(*column_names)
    	end
	end
	end
end

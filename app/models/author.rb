class Author < ApplicationRecord
	has_many :books, dependent:   :destroy
	validates :author_name, presence: true, length: {maximum: 50 }
	def self.search(search)
  # Title is for the above case, the OP incorrectly had 'name'
 	 where('author_name LIKE ?', "%#{search}%")
	end
	def self.to_csv(a)
		CSV.generate do |csv|
		csv << column_names
    	all.each do |author|
     	csv << author.attributes.values_at(*column_names)
    	end
	end
	end
end

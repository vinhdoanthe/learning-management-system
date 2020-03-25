module User
	class Reaction < ApplicationRecord
	  belongs_to :user
	end
end

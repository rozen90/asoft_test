class MainController < ApplicationController

	def index
		@products = Product.find_by_sql("select * from products where created_at = (select created_at from products group by created_at desc limit 1)")
	end

end

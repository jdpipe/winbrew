require 'hardware'

module Windows extend self

	def canonicalize path
		`sh -c 'cd #{path}; pwd -W'`.strip
	end

end
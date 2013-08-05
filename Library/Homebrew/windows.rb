require 'hardware'

module Windows extend self

	def canonicalize path
		`sh -c 'cd #{path}; pwd -W'`.strip
	end

  def wmic category, property
    `wmic #{category} get #{property}`.split("\n")[2].strip
  end

end
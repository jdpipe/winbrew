module Homebrew extend self
  def unlink
    raise KegUnspecifiedError if ARGV.named.empty?

    ARGV.kegs.each do |keg|
      keg.lock do
        unless keg.linked?
          opoo "Not linked: #{keg}"
          puts "To link: brew link #{keg.fname}"
          next
        end

        print "Unlinking #{keg}... "
        puts "#{keg.unlink} links removed"
      end
    end
  end
end

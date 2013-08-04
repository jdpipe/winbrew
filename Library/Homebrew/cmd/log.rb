module Homebrew extend self
  def log
    if ARGV.named.empty?
      cd HOMEBREW_REPOSITORY
      exec "sh -c 'git log #{ARGV.options_only.join('')}'"
    else
      begin
        path = ARGV.formulae.first.path.realpath
      rescue FormulaUnavailableError
        # Maybe the formula was deleted
        path = HOMEBREW_REPOSITORY/"Library/Formula/#{ARGV.named.first}.rb"
      end
      cd path.dirname # supports taps
      exec "sh -c 'git log #{ARGV.options_only.join('')} -- #{path}'"
    end
  end
end

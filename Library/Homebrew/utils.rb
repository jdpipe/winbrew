require 'pathname'
require 'exceptions'
require 'macos'
require 'utils/json'
require 'utils/inreplace'
require 'open-uri'

class Tty
  class << self
    def blue; bold 34; end
    def white; bold 39; end
    def red; underline 31; end
    def yellow; underline 33 ; end
    def reset; escape 0; end
    def em; underline 39; end
    def green; color 92 end
    def gray; bold 30 end

    def width
      if MACOS
        `/usr/bin/tput cols`.strip.to_i
      else
        `stty size`.split(' ')[1].to_i
      end
    end

    def truncate(str)
      str.to_s[0, width - 4]
    end

    private

    def color n
      escape "0;#{n}"
    end
    def bold n
      escape "1;#{n}"
    end
    def underline n
      escape "4;#{n}"
    end
    def escape n
      "\033[#{n}m" if $stdout.tty?
    end
  end
end

def ohai title, *sput
  title = Tty.truncate(title) if $stdout.tty? && !ARGV.verbose?
  puts "#{Tty.blue}==>#{Tty.white} #{title}#{Tty.reset}"
  puts sput unless sput.empty?
end

def oh1 title
  title = Tty.truncate(title) if $stdout.tty? && !ARGV.verbose?
  puts "#{Tty.green}==>#{Tty.white} #{title}#{Tty.reset}"
end

def opoo warning
  STDERR.puts "#{Tty.red}Warning#{Tty.reset}: #{warning}"
end

def onoe error
  lines = error.to_s.split("\n")
  STDERR.puts "#{Tty.red}Error#{Tty.reset}: #{lines.shift}"
  STDERR.puts lines unless lines.empty?
end

def ofail error
  onoe error
  Homebrew.failed = true
end

def odie error
  onoe error
  exit 1
end

def pretty_duration s
  return "2 seconds" if s < 3 # avoids the plural problem ;)
  return "#{s.to_i} seconds" if s < 120
  return "%.1f minutes" % (s/60)
end

def interactive_shell f=nil
  unless f.nil?
    ENV['HOMEBREW_DEBUG_PREFIX'] = f.prefix
    ENV['HOMEBREW_DEBUG_INSTALL'] = f.name
  end

  Process.spawn 'sh --login -i'
  Process.wait
  unless $?.success?
    puts "Aborting due to non-zero exit status"
    exit $?
  end
end

module Homebrew
  def self.system cmd, *args
    puts "#{cmd} #{args*' '}" if ARGV.verbose?
    args.collect!{|arg| arg.to_s}

    begin
      Process.spawn cmd, *args
    rescue => e
      # Shut up, that's real clean code.
      # But if you know how to write it better, let me know - A.
      msg = "#{e}"
      if msg.include? "Exec format error"
        # Shell file, needs sh, can't be spawned with Win32 APIs
        Process.spawn "sh", "-c", cmd + ' "$@"', "--", *args
      elsif msg.include? "No such file"
        # Might be executable without the'.exe' extension, shell will find it
        Process.spawn "sh", "-c", cmd + ' "$@"', "--", *args
      else
        raise e
      end
    end

    Process.wait
    $?.success?
  end
end

def with_system_path
  old_path = ENV['PATH']
  ENV['PATH'] = '/usr/bin;/mingw/bin'
  yield
ensure
  ENV['PATH'] = old_path
end

# Kernel.system but with exceptions
def safe_system cmd, *args
  unless Homebrew.system cmd, *args
    args = args.map{ |arg| arg.to_s.gsub " ", "\\ " } * " "
    raise ErrorDuringExecution, "Failure while executing: #{cmd} #{args}"
  end
end

# prints no output
def quiet_system cmd, *args
  Homebrew.system(cmd, *args) do
    # Redirect output streams to `/dev/null` instead of closing as some programs
    # will fail to execute if they can't write to an open stream.
    $stdout.reopen('/dev/null')
    $stderr.reopen('/dev/null')
  end
end

def curl *args
  curl = MacOS.locate 'curl'
  raise "curl not found" unless curl

  args = [HOMEBREW_CURL_ARGS, HOMEBREW_USER_AGENT, *args]
  # See https://github.com/mxcl/homebrew/issues/6103
  args << "--insecure" if MacOS.version < 10.6
  args << "--verbose" if ENV['HOMEBREW_CURL_VERBOSE']
  args << "--silent" unless $stdout.tty?

  safe_system curl, *args
end

def puts_columns items, star_items=[]
  return if items.empty?

  if star_items && star_items.any?
    items = items.map{|item| star_items.include?(item) ? "#{item}*" : item}
  end

  if $stdout.tty?
    # determine the best width to display for different console sizes
    console_width = `stty size`.chomp.split(" ").last.to_i
    console_width = 80 if console_width <= 0
    longest = items.sort_by { |item| item.length }.last
    optimal_col_width = (console_width.to_f / (longest.length + 2).to_f).floor
    cols = optimal_col_width > 1 ? optimal_col_width : 1

    IO.popen("pr -#{cols} -t -w#{console_width}", "w"){|io| io.puts(items) }
  else
    puts items
  end
end

def which cmd, path=ENV['PATH']
  # Path separator is ';' on Windows, executable end with '.exe'
  dir = path.split(';').find {|p| File.exist? File.join(p, "#{cmd}.exe")} if dir.nil?
  Pathname.new(File.join(dir, "#{cmd}.exe")) unless dir.nil?
end

def which_editor
  editor = ENV.values_at('HOMEBREW_EDITOR', 'VISUAL', 'EDITOR').compact.first
  # If an editor wasn't set, try to pick a sane default
  return editor unless editor.nil?

  # Find Textmate
  return 'mate' if which "mate"
  # Find # BBEdit / TextWrangler
  return 'edit' if which "edit"
  # Default to vim
  return '/usr/bin/vim'
end

def exec_editor *args
  return if args.to_s.empty?
  safe_exec(which_editor, *args)
end

def exec_browser *args
  browser = ENV['HOMEBREW_BROWSER'] || ENV['BROWSER']
  if MACOS
    browser ||= "open"
  elsif WIN32
    browser ||= "start"
  end
  safe_exec(browser, *args)
end

def safe_exec cmd, *args
  # This buys us proper argument quoting and evaluation
  # of environment variables in the cmd parameter.
  exec "sh", "-i", "-c", cmd + ' "$@"', "--", *args
end

# GZips the given paths, and returns the gzipped paths
def gzip *paths
  paths.collect do |path|
    system "/usr/bin/gzip", path
    Pathname.new("#{path}.gz")
  end
end

# Returns array of architectures that the given command or library is built for.
def archs_for_command cmd
  cmd = which(cmd) unless Pathname.new(cmd).absolute?
  Pathname.new(cmd).archs
end

def ignore_interrupts(opt = nil)
  std_trap = trap("INT") do
    puts "One sec, just cleaning up" unless opt == :quietly
  end
  yield
ensure
  trap("INT", std_trap)
end

def nostdout
  if ARGV.verbose?
    yield
  else
    begin
      require 'stringio'
      real_stdout = $stdout
      $stdout = StringIO.new
      yield
    ensure
      $stdout = real_stdout
    end
  end
end

module GitHub extend self
  ISSUES_URI = URI.parse("https://api.github.com/legacy/issues/search/mxcl/homebrew/open/")

  Error = Class.new(StandardError)

  def open url, headers={}, &block
    require 'net/https' # for exception classes below

    default_headers = {'User-Agent' => HOMEBREW_USER_AGENT}
    default_headers['Authorization'] = "token #{HOMEBREW_GITHUB_API_TOKEN}" if HOMEBREW_GITHUB_API_TOKEN
    Kernel.open(url, default_headers.merge(headers), &block)
  rescue OpenURI::HTTPError => e
    if e.io.meta['x-ratelimit-remaining'].to_i <= 0
      raise <<-EOS.undent
        GitHub #{Utils::JSON.load(e.io.read)['message']}
        You may want to create an API token: https://github.com/settings/applications
        and then set HOMEBREW_GITHUB_API_TOKEN.
        EOS
    else
      raise e
    end
  rescue SocketError, OpenSSL::SSL::SSLError => e
    raise Error, "Failed to connect to: #{url}\n#{e.message}"
  end

  def each_issue_matching(query, &block)
    uri = ISSUES_URI + query
    open(uri) { |f| Utils::JSON.load(f.read)['issues'].each(&block) }
  end

  def issues_for_formula name
    # bit basic as depends on the issue at github having the exact name of the
    # formula in it. Which for stuff like objective-caml is unlikely. So we
    # really should search for aliases too.

    name = f.name if Formula === name

    issues = []

    each_issue_matching(name) do |issue|
      # don't include issues that just refer to the tool in their body
      issues << issue['html_url'] if issue['title'].include? name
    end

    issues
  end

  def find_pull_requests rx
    query = rx.source.delete('.*').gsub('\\', '')

    each_issue_matching(query) do |issue|
      if rx === issue['title'] && issue.has_key?('pull_request_url')
        yield issue['pull_request_url']
      end
    end
  end
end

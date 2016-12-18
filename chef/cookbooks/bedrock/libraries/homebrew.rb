#
module Bedrock
  #
  module Homebrew
    def xcode_clt_installed?
      selector = '/usr/bin/xcode-select'
      if File.exist?(selector)
        begin
          path = `#{selector} --print-path`
          $?.success? && path =~ %r{^/Applications/Xcode.app/}
        rescue
          false
        end
      else
        false
      end
    end
  end
end

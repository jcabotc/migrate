require 'script/base'

class TestScript < Migrate::Script::Base

  def run
    log 'running', :as => :extreme
  end

end

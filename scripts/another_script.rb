require 'script/base'

class AnotherScript < Migrate::Script::Base

  old_model :interest_area
  new_model :interest_zone

  def run
    log 'copying interest areas to interest zones', :as => :title

    InterestArea.all.each do |interest_area|
      InterestZone.create! do |interest_zone|
        log interest_area.code, :as => :list
        interest_zone.name = interest_area.code
      end
    end
  end

end

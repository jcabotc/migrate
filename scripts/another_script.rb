require 'script/base'

class AnotherScript < Migrate::Script::Base

  def prepare_models
    old.model :interest_area
    new.model :interest_zone
  end

  def run
    prepare_models

    InterestArea.all.each do |interest_area|
      InterestZone.create! do |interest_zone|
        interest_zone.name = interest_area.code
      end
    end
  end

end

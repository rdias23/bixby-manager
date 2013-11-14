# == Schema Information
#
# Table name: metadata
#
#  id     :integer          not null, primary key
#  key    :string(255)      not null
#  value  :text             not null
#  source :integer          default(1), not null
#


class Metadata < ActiveRecord::Base

  module Type
    HOST       = 1
    METRIC     = 2
  end
  Bixby::Util.create_const_map(Type)

  module Source
    CUSTOM = 1
    METRIC = 2
    FACTER = 3
  end
  Bixby::Util.create_const_map(Source)

  def source_name
    Source.lookup(@source).to_s
  end

end

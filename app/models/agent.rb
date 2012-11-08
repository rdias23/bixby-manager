
class Agent < ActiveRecord::Base

  belongs_to :host
  acts_as_paranoid

  STATUS_NEW      = 0
  STATUS_ACTIVE   = 1
  STATUS_INACTIVE = 2

  # validations
  validates_presence_of :port, :uuid, :public_key
  validates_uniqueness_of :uuid, :public_key


  # Lookup an Agent by UUID
  #
  # @param [String] uuid      UUID to lookup
  #
  # @return [Agent] agent if found, or else nil
  def self.for_uuid(uuid)
    ret = where("uuid = ?", uuid)
    return ret.blank?() ? nil : ret.first
  end

  # Shortcut accessor for this Agent's Org
  #
  # @return [Org]
  def org
    self.host.org
  end

  # Shortcut accessor for this Agent's Tenant
  #
  # @return [Tenant]
  def tenant
    self.org.tenant
  end

  def uri
    "http://#{self.ip}:#{self.port}/"
  end

end

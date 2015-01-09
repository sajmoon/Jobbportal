class Role
  def self.admin
    "admin"
  end

  def self.rep
    "company_rep"
  end

  def self.get_user(warden)
    user = warden.user
    if user.nil?
      user = warden.user(:company)
    end
    if user.nil?
      user = warden.user(:admin)
    end
    user
  end
end

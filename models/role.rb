class Role
  def self.admin
    "admin"
  end

  def self.rep
    "company_rep"
  end

  def self.get_hash_of_roles(user)
    list = [ { :n => Role.admin, :selected => false },
      { :n => Role.rep, :selected => false } ]
    list.each do |i|
      puts user.name
      puts user.role
      puts i[:n]
      if i[:n] == user.role
        puts true
        i[:selected] = true
      end
    end
    puts list
    list
  end

  #deprecatead right?
  def self.is_company_rep(warden, company_id = 0)
    if (warden.authenticated?(:company) && warden.user.id = company_id )|| warden.authenticated?(:admin)
      true
    else
      false
    end
  end

  def self.is_admin(warden)
    if warden.authenticated?(:company) && warden.user(:company).admin?
      true
    else
      false
    end
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

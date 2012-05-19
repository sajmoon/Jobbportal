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
end
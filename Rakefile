%w[bundler rake/testtask].each { |lib| require lib }

task :default => :spec

Rake::TestTask.new(:spec) do |t|
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
end

namespace :db do
  desc "Rebuild database (destructive migrations)"
  task :auto_migrate do
    require_relative "boot.rb"
    DataMapper.auto_migrate!
    puts "Auto Migrate complete!"
  end

  desc "Run database migrations (non-destructive)"
  task :auto_upgrade do
    require_relative "boot.rb"
    DataMapper.auto_upgrade!
    puts "Auto Upgrade complete!"
  end

  desc "Seed a standard admin user, admin@d.kth.se, password: admin"
  task :seed do
    require_relative"boot.rb"
    admin = User.new(first_name: "Admin", last_name: "Admin", email: "admin@d.kth.se", role: Role.admin, salt: "adminsaltish", hashedpassword: admin.encryptpassword("admin", "adminsaltish"))

    admin.save

    admin.errors.each do |e|
      puts "Error: #{e.to_s}"
    end

  end
end



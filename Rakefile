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

  namespace :seed do

    desc "Clear all data"
    task :clear do
      puts "Clear all companies"
      require_relative "boot.rb"
      Company.all.destroy
    end

    desc "Seed a standard admin user, admin@d.kth.se, password: admin"
    task :datasektionen do
      require_relative "boot.rb"

      admin = Company.first(email: "admin@d.kth.se")
      
      unless admin.nil?
        puts "Ta bort Datasektionen"
        admin.destroy!
      end

      puts "Skapa Datasektionen"
      admin = Company.new(name: "Datasektionen", email: "admin@d.kth.se", role: Role.admin, salt: "adminsaltish", password: "admin")

      admin.save

      admin.errors.each do |e|
        puts "Error: #{e.to_s}"
      end
    end

    desc "Seed some standard categories"
    task :categories do
      require_relative "boot.rb"
      ["Heltid", "Deltid", "Sommarjobb"].each do |c|
        puts "Create category: #{c}"
        cat = Category.new(name: c)
        cat.save!
      end
    end

    desc "Seed a set of standard companies"
    task :companies do
      require_relative "boot.rb"
      ["Fristaende", "Datasektionen"].each do |i|
        puts "Creating company: #{i}"
        c = Company.new(name: i, created_at: Time.now)
        c.save!
      end
    end
  end
end



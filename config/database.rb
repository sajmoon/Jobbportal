##
# A MySQL connection:
# DataMapper.setup(:default, 'mysql://user:password@localhost/the_database_name')
#
# # A Postgres connection:
# DataMapper.setup(:default, 'postgres://user:password@localhost/the_database_name')
#
# # A Sqlite3 connection
# DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "development.db"))
#

# DataMapper.logger = logger
DataMapper::Property::String.length(255)

case SINATRA_ENV
  when "development" then DataMapper.setup(:default, "sqlite3://" + SINATRA_ROOT + "/db/development.db")
  when "production"  then DataMapper.setup(:default, ENV['DATABASE_URL'] || {:database => 'ideator_dev', :adapter => 'postgres'} )
  when "test"        then DataMapper.setup(:default, "sqlite::memory:")
end
DataMapper.finalize

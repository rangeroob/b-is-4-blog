task :createdb do
  ruby "setup/createdb.rb"
end

task :removedb do
  ruby "setup/removedb.rb"
end

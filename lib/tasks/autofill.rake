desc "Autofill groups"
task :autofill => :environment do
  Group.autofill
end

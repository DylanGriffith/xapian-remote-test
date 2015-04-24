require 'xapian'
require 'pathname'
require 'protobuf'
require 'base64'

database = Xapian::Database.new

database.add_database(Xapian::Database.new(Xapian::remote_open("ssh", "localhost xapian-progsrv #{Pathname.new("./output_database1").expand_path}")))
database.add_database(Xapian::Database.new(Xapian::remote_open("ssh", "localhost xapian-progsrv #{Pathname.new("./output_database2").expand_path}")))

enquire = Xapian::Enquire.new(database)

enquire.query = Xapian::Query::MatchAll

enquire.sort_by_value!(0, true)

# Limit to 100 results
matchset = enquire.mset(0, 100)

values = []
matchset.matches.each {|m|
  document = m.document
  value = document.value(0)
  values << value
}

database.close

if values != values.sort.reverse
  puts "Out of order: #{values.count}"
else
  puts "In order: #{values.count}"
end

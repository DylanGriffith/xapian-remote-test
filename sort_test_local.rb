#!/usr/bin/env ruby

require 'xapian'
require 'pathname'

database = Xapian::Database.new

database.add_database(Xapian::Database.new(Pathname.new("./database1").to_s))
database.add_database(Xapian::Database.new(Pathname.new("./database2").to_s))

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

if values == values.sort.reverse
  puts "In order: #{values.count}"
elsif values == values.sort
  puts "Reverse order: #{values.count}"
else
  puts "Out of order: #{values.count}"
end

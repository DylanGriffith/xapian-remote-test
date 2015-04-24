#!/usr/bin/env ruby

require 'xapian'
require 'pathname'

database = Xapian::Database.new

server1 = fork { system("xapian-tcpsrv -p 9998 database1") }
server2 = fork { system("xapian-tcpsrv -p 9999 database2") }

sleep(3)

database.add_database(Xapian::Database.new(Xapian::remote_open("localhost", 9998)))
database.add_database(Xapian::Database.new(Xapian::remote_open("localhost", 9999)))

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
Process.kill("HUP", server1)
Process.kill("HUP", server2)

if values == values.sort.reverse
  puts "In order: #{values.count}"
elsif values == values.sort
  puts "Reverse order: #{values.count}"
else
  puts "Out of order: #{values.count}"
end

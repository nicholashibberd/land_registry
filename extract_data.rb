require 'pdf-reader'
require 'csv'
require 'pry'

File.open('./example_register.pdf', 'r') do |io|
  reader = PDF::Reader.new(io)

  register_extract = /REGISTER EXTRACT(.|\n)*/.match(reader.pages.first.text)[0]

  title_number = /Title Number.*(CS[0-9]*)/.match(register_extract)[1]
  address = /Address of Property\s*:\s(.*)/.match(register_extract)[1]

  CSV.open('./output.csv', 'w') do |csv|
    csv << ['Title Number', 'Address', 'Proprietor']
    csv << [title_number, address, nil]
  end
end

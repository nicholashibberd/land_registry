require 'pdf-reader'
require 'csv'
require 'pry'

def remove_whitespace(text)
  text.gsub(/\n/, '').gsub(/  */, " ").gsub(": ", "")
end

File.open('./example_register.pdf', 'r') do |io|
  reader = PDF::Reader.new(io)

  register_extract = /REGISTER EXTRACT(.|\n)*/.match(reader.pages.first.text)[0]

  sections = register_extract.split("\n\n")

  title_number_section = sections.detect {|s| s =~ /Title Number/}
  address_section = sections.detect {|s| s =~ /Address/}
  price_section = sections.detect {|s| s =~ /Price Paid\/Value Stated/}
  owners_section = sections.detect {|s| s =~ /Registered Owners/}
  lender_section = sections.detect {|s| s =~ /Lender/}

  title_number = /Title Number.*(CS[0-9]*)/.match(title_number_section)[1]
  address = /Address of Property\s*:\s(.*)/.match(address_section)[1]
  price = /Price Paid\/Value Stated\s*:\s(.*)/.match(price_section)[1]
  owners = remove_whitespace(/Registered Owners\s*:\s(.*)/m.match(owners_section)[1])
  lender = /Lender\s*:\s(.*)/.match(lender_section)[1]

  CSV.open('./output.csv', 'w') do |csv|
    csv << ['Title Number', 'Address', 'Price Paid', 'Owners', 'Lender']
    csv << [title_number, address, price, owners, lender]
  end
end

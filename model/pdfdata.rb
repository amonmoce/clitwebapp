require 'aws-sdk'

class Pdfdata < AWS::Record::HashModel

  string_attr  "pdfdata"
  string_attr  "classid"
  timestamps

end

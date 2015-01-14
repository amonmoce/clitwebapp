require 'aws-sdk'

class Pdfdata < AWS::Record::HashModel

  string_attr  "pdfdata"
  string_attr  "classid"
  string_attr  "english"
  string_attr  "mandarin_tr"
  string_attr  "spanish"
  string_attr  "ukrainian"
  string_attr  "vietnamese"
  string_attr  "indonesian"
  string_attr  "malaysian"
  timestamps

end

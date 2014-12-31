require 'aws-sdk'

class Registered < AWS::Record::HashModel

  string_attr     "classname"
  string_attr     "classcode"
  string_attr     "teachercode"
  timestamps

end

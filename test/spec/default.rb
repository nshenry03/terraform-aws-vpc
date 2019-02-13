# See
# * [Example|http://bit.ly/2GqgA9P]
# * [Documentation|https://github.com/k1LoW/awspec]

require 'awspec'
require 'aws-sdk'
require 'rhcl'

example_main = Rhcl.parse(File.open('examples/test_fixture/main.tf'))

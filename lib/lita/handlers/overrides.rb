# Overrides can be added to the Zerocater response by adding a key-value pair to the OVERRIDES hash,
# where the key is some unique tag, and the value is a two-item list containing the list of affected dates,
# and the override response you wish to send back to slack.
require_relative 'overrides/max_prank_template'

OVERRIDES = {
  :week_of_max_prank => [
    [Date.new(2018,10,29), Date.new(2018,10,30), Date.new(2018,10,31), Date.new(2018,11,1), Date.new(2018,11,2)],
    MAX_PRANK_TEMPLATE
  ]
}.freeze

OVERRIDE_LIST = Hash[OVERRIDES.collect { |k, v|  v[0].map { |date| [date, k] } }.flatten(1)].freeze

def override_menu(override_tag)
  OVERRIDES[override_tag][1]
end

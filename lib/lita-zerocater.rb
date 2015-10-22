require 'lita'

Lita.load_locales Dir[File.expand_path(
  File.join('..', '..', 'locales', '*.yml'), __FILE__
)]

require 'nokogiri'
require 'unidecoder'

require 'lita/handlers/zerocater'

Lita::Handlers::Zerocater.template_root File.expand_path(
  File.join('..', '..', 'templates'),
  __FILE__
)

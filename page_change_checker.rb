#!/usr/bin/env ruby
#
# Sends an email when page matches pattern

require 'logger'
require 'rest-client'

silent_output = false

$logger = Logger.new(STDOUT)
$logger.level = (silent_output ? Logger::ERROR : Logger::DEBUG)

email_key = 'api:key-nope'
email_url = 'api.mailgun.net/v3/mail.arethsu.se/messages'

email_meta = { from: 'Emilia Michanek <hello@mail.arethsu.se>', to: 'xxx.xxx@gmail.com' }
email_data = { subject: 'Page matches pattern', text: 'A recent scan revealed a pattern match. :D' }

def send_email(key, url, from, to, subject, text)
  RestClient.post("https://#{key}@#{url}", from: from, to: to, subject: subject, text: text)
end

page_url = 'https://xyz.xy/register/apply'
page_pattern = 'Sorry, applications are <strong>temporarily</strong> closed'

def matches_pattern?(url, pattern)
  RestClient.get(url).include?(pattern)
end

loop do
  if !matches_pattern?(page_url, page_pattern)
    send_email(email_key, email_url, email_meta[:from], email_meta[:to], email_data[:subject], email_data[:text])
    $logger.info('match returned true, email was sent')
    exit
  else
    $logger.info('match returned false')
  end

  # 120, 300, 600, 1800
  sleep 120
  # sleep (Random.rand(3) * 60) + 120 + (Random.rand(2) * 30)
end

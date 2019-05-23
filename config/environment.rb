# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Setting ActionMailer to setting to SendGrid's servers
ActionMailer::Base.smtp_settings = {
  user_name: ENV['SENDGRID_USERNAME'],
  password: ENV['SENDGRID_PASSWORD'],
  domain: 'herokuapp.com',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}

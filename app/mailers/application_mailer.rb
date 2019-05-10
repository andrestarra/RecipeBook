# frozen_string_literal: true

# Application Mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'recipe@book.com'
  layout 'mailer'
end

configure :development do
  require "better_errors"

  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

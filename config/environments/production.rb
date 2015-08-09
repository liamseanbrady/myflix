Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.action_mailer.smtp_settings = {
    address: "smtp.mailgun.org",
    port: 587,
    domain: "sandbox1d53072f892547b491c355ba4c9ba567.mailgun.org",
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: ENV["MAIL_USERNAME"],
    password: ENV["MAIL_PASSWORD"]
  }
end

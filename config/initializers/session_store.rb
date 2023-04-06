Rails.application.config.session_store(
    :cookie_store,
    key: '_app_session',
    httponly: true,
    expire_after: 14.days
)

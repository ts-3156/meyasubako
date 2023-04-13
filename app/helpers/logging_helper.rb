module LoggingHelper
  def create_access_log
    AccessLog.create(
        controller: controller_path,
        action: action_name,
        method: request.method,
        path: request.path,
        params: save_params,
        status: response.status,
        ip: request.ip,
        browser: request.browser,
        os: request.os,
        device_type: request.device_type,
        user_agent: ensure_utf8(request.user_agent),
        referer: request.referer,
        time: Time.zone.now,
    )
  rescue => e
    logger.warn e.inspect
  end

  def save_params
    request.query_parameters.merge(request.request_parameters).except(:locale, :utf8, :authenticity_token)
  end

  def ensure_utf8(str)
    str&.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  end

end

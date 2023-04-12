module SurveysHelper
  def auto_link_description(survey)
    # TODO Fix performance issue
    auto_link(survey.description.gsub(/\r?\n/, '<br>'), link: :urls, html: {target: '_blank'})
  end
end

module FormsHelper
  def question_field_tag(type, name, id:, _class:, required: false)
    if type == 'text'
      text_field_tag name, '', id: id, class: _class, required: required
    else
      text_area_tag(name, '', id: id, class: _class, rows: 10, required: required)
    end
  end
end

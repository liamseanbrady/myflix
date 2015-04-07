module ApplicationHelper
  def form_for_with_errors(object, options = {}, &block)
    form_for(object, options.merge!(builder: CustomFormBuilder), &block)
  end

  def options_for_video_reviews(selected = nil)
    options_for_select((1..5).map { |number| [pluralize(number, 'Star'), number] }, selected)
  end
end

module ApplicationHelper
  def form_for_with_errors(object, options = {}, &block)
    form_for(object, options.merge!(builder: CustomFormBuilder), &block)
  end
end

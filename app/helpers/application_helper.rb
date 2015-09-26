module ApplicationHelper
  def simple_format(input, *args)
    super(h input, *args)
  end

  def wip_class
    "#{Rails.env}-wip"
  end

  def processing_action?(controller, *actions)
    params[:controller] == controller && actions.include?(params[:action])
  end

  def page_title
    [page_title_fragment, 'AWS Monitor'].compact.join(' | ')
  end

  private

  def page_title_fragment
    if content_for? :title
      content_for :title
    elsif current_entity.respond_to? :name
      current_entity.name.presence
    end
  rescue
  end
end

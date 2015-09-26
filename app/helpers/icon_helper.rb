module IconHelper
  def badge(count, css_class: "badge-#{count}")
    content_tag(:div, count, class: "badge #{css_class}")
  end

  def masked_badge_unless(condition, count)
    if condition || count == 0
      badge(count)
    else
      badge(Icons::EXCLAMATION, css_class: 'icon')
    end
  end

  def icon(value, options = {})
    options[:class] = [options[:class], 'icon'].compact.join(' ')
    content_tag :span, value, options
  end

  Icons.constants.each do |icon|
    value = "Icons::#{icon}".constantize
    define_method "#{icon.to_s.downcase}_icon" do |options = {}|
      icon(value, options)
    end
  end

  def icon_type(filename)
    case extension(filename)
    when 'mp3', 'ogg', 'ra', 'wav', 'wma'
      'audio'
    when 'xls', 'xlsx', 'numbers', 'ods'
      'excel'
    when 'bmp', 'gif', 'jpg', 'jpeg', 'png', 'svg', 'tiff'
      'image'
    when 'pdf'
      'pdf'
    when 'ppt', 'pptx', 'key'
      'powerpoint'
    when 'aaf', 'avi', 'divx', 'mov', 'mp4', 'mpg', 'qt', 'rm', 'swf', 'wmv'
      'video'
    when 'doc', 'docx', 'txt', 'pages'
      'word'
    else
      'other'
    end
  end

  def extension(filename)
    File.extname(filename).sub(/^\./, '').downcase
  end
end

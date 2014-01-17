module MicropostsHelper
  @@reply_to_regexp = /\A@([^\s]*)/

  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

  def link(content)
    if match = @@reply_to_regexp.match(content)
      if user = User.find_by_email(match[1])
        content.gsub(/\A@([^\s]*)/) {link_to("@#{user.name}", user_path(user))} 
      else
        content
      end
    else
      content
    end
  end

  private

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      (text.length < max_width) ? text :
                                  text.scan(regex).join(zero_width_space)
    end
end
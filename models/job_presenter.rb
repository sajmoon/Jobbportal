module JobPresenter
  def apply_link
    url = "mailto:#{company.email}"
    if !apply_url.empty?
      if is_complete_url
        url = apply_url
      else
        url = "http://#{apply_url}"
      end
    end
    url
  end

  def is_complete_url
    apply_url.match("^http://|https://")
  end
end

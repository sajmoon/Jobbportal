module JobPresenter
  def apply_link
    url = "mailto:#{company.email}"
    if !apply_url.empty?
      if apply_url.match('^http://|https://')
        url = apply_url
      else
        url = "http://#{apply_url}"
      end
    end
    url
  end
end

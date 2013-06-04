class WebpagePreviewGenerator
  include SourceLogger
  include Singleton

  def generate(name, url)
    logger.info "Creating webpage preview for #{url}"
    begin
      logger.info IMGKit.object_id
      jpg = IMGKit.new(url,quality: 50,width: 600).to_jpg
      logger.info "Successfully fetched webpage preview for #{url}"
    rescue
      jpg = nil
      logger.warn "Failed to fetch webpage preview for #{url}"
      logger.warn $!
    end
    save_to_file(name, jpg) if jpg
  end

  private
  def save_to_file(name, jpg)
    filename = name
    file = File.new("public/images/preview/"+filename, "w")
    file.write(jpg)
    file.flush
    file.close
    file_url = "/images/preview/"+filename
    logger.info("Saved webpage preview to #{file_url}")
    file_url
  end
end
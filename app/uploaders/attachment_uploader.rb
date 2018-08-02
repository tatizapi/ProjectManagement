class AttachmentUploader < CarrierWave::Uploader::Base
  configure do |config|
    config.remove_previously_stored_files_after_update = false
  end
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    'uploads'
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def is_image
    %w(jpg jpeg gif png bmp).include?(get_extension)
  end

  def is_video
    %w(mp4 avi wmv mov).include?(get_extension)
  end

  def is_audio
    %w(mp3 wma wav).include?(get_extension)
  end

  def is_pdf
    %w(pdf).include?(get_extension)
  end

  def is_other
    !is_image && !is_video && !is_audio && !is_pdf 
  end

  private

  def get_extension
    self.file.extension.downcase
  end

end

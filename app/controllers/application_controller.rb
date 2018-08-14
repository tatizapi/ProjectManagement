class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def save_files(container, files)
    if files
      files.each do |file|
        container.attachments.create(file_params(file))
      end
    end
  end

  private

  def file_params(file)
    { "filename": file.original_filename, "file_type": file.content_type, "file": file }
  end
end

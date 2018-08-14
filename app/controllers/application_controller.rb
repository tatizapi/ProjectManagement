class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def setup_left_sidebar
    case current_user.type
    when 'Admin'
      @projects = Project.all
    when 'Employee'
      @projects_projectmanager_role, @projects_developer_role, @projects_tester_role = Employee.get_employees_filtered_by_role(current_user.id)
    when 'Client'
      @projects = Client.find(current_user.id).projects
    end
  end

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

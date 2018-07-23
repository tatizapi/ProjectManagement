module Admin
  class EmployeesController < ApplicationController
    def index
      @employees = Employee.all
    end

    def new
      @employee = Employee.new
    end

    def create
      @employee = Employee.new(employee_params)
      if @employee.save
        redirect_to admin_employees_path
      else
        render 'new'
      end
    end

    def edit
      @employee = Employee.find(params[:id])
    end

    def update
      @employee = Employee.find(params[:id])
      if @employee.update(employee_params)
        redirect_to admin_employees_path
      else
        render 'edit'
      end
    end

    def destroy
      @employee = Employee.find(params[:id])
      @employee.destroy
      redirect_to admin_employees_path
    end

    private
    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :username,
                                       :password, :email, :function, :attachment)
    end

  end
end
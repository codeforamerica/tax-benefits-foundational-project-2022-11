class BenefitsApplicationsController < ApplicationController
  def index
    @apps = BenefitApp.all
  end

  def new
    @form = BenefitApp.new
  end

  def create

    puts benefits_permitted_params
    @form = BenefitApp.create(benefits_permitted_params)
    if @form.valid?
      redirect_to root_path
    else
      puts @form.errors.messages
      render :new, form: @form
    end
  end

  private

  def benefits_permitted_params
    params.require(:benefit_app).permit(:email_address, :address, :phone_number)
  end
end

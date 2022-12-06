class BenefitsApplicationsController < ApplicationController
  def index
    @apps = BenefitApp.all
  end

  def new
    puts 'we are in the new controller action'
    @form = BenefitApp.new
    @form_object_id = @form.object_id
  end

  def create

    puts benefits_permitted_params
    @form = BenefitApp.new(benefits_permitted_params)
    @form_object_id = @form.object_id
    puts "object id=#{ @form.object_id}"
    if @form.valid?
      @form.save
      redirect_to root_path
    else
      puts @form.errors.present?
      puts @form.errors.messages
      render :new
    end
  end

  private

  def benefits_permitted_params
    params.require(:benefit_app).permit(:email_address, :address, :phone_number)
  end
end

class BenefitsApplicationsController < ApplicationController
  def index
    @apps = BenefitApp.all
  end

  def new
    @form = BenefitApp.new
  end

  def new_primary_member
    @form = current_benefit_app&.build_primary_member
  end

  def create
    @form = BenefitApp.new(benefits_permitted_params)
    if @form.valid?
      @form.save
      session[:benefit_app_id] = @form.id
      redirect_to new_primary_member_path
    else
      render :new
    end
  end

  def create_primary_member
    benefit_app = current_benefit_app
    @form = benefit_app.build_primary_member(primary_member_permitted_params)
    if @form.valid?
      @form.save
      benefit_app.update(submitted_at: Date.today)
      redirect_to root_path
    else
      render :new_primary_member
    end
  end

  private

  def primary_member_permitted_params
    params.require(:member).permit(:first_name, :last_name, :date_of_birth)
  end

  def benefits_permitted_params
    params.require(:benefit_app).permit(:email_address, :address, :phone_number)
  end

  def current_benefit_app
    benefit_app_id = session[:benefit_app_id]
    BenefitApp.find(benefit_app_id) unless benefit_app_id.nil?
  end
end

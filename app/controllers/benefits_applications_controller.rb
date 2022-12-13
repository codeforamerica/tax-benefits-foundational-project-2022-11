class BenefitsApplicationsController < ApplicationController
  def index
    @apps = BenefitApp.all
  end

  def new
    @form = BenefitApp.new
  end

  def new_member
    # TODO: make an instance variable which exposes primary vs. secondary so that we can adapt the view
    benefit_app = current_benefit_app
    if benefit_app.primary_member.present?
      @form = benefit_app&.secondary_members.build
    else
      @form = benefit_app&.build_primary_member
    end
  end

  def create
    @form = BenefitApp.new(benefits_permitted_params)
    if @form.valid?
      @form.save
      session[:benefit_app_id] = @form.id
      redirect_to new_member_path
    else
      render :new
    end
  end

  def create_member
    benefit_app = current_benefit_app
    had_primary_member = benefit_app&.primary_member.present?

    if had_primary_member
      @form = benefit_app.secondary_members.build(member_permitted_params)
    else
      @form = benefit_app.build_primary_member(member_permitted_params)
    end

    if @form.valid?
      @form.save
      benefit_app.update(submitted_at: Date.today) unless had_primary_member
      redirect_to new_member_path
    else
      render :new_member
    end
  end

  def validate_application
    benefit_app = current_benefit_app
    if benefit_app&.primary_member.present?
      redirect_to root_url
    else
      render :new_member
    end
  end

  private

  def member_permitted_params
    params.require(:member).permit(:first_name, :last_name, :date_of_birth, :is_primary)
  end

  def benefits_permitted_params
    params.require(:benefit_app).permit(:email_address, :address, :phone_number)
  end

  def current_benefit_app
    benefit_app_id = session[:benefit_app_id]
    BenefitApp.find(benefit_app_id) unless benefit_app_id.nil?
  end
end

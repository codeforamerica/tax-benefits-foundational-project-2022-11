class BenefitsApplicationsController < ApplicationController
  def index
    @apps = BenefitApp.all
  end

  def new
    @benefit_app_form = BenefitApp.new
  end

  def create
    @benefit_app_form = BenefitApp.new(benefits_permitted_params)
    if @benefit_app_form.save
      session[:benefit_app_id] = @benefit_app_form.id
      redirect_to new_member_path
    else
      render :new
    end
  end

  def new_member
    benefit_app = current_benefit_app
    @is_primary = benefit_app.primary_member.present?
    @members = current_members(benefit_app)
    if @is_primary
      @secondary_member_form = benefit_app&.secondary_members.build
      render :new_secondary_member
    else
      @primary_member_form = benefit_app&.build_primary_member
      render :new_member
    end
  end

  def edit_member
    @member = Member.find(params[:id])
    render :edit_member
  end

  def create_member
    benefit_app = current_benefit_app
    @members = current_members(benefit_app)
    built_member = build_member(benefit_app)

    if benefit_app&.primary_member.present?
      @secondary_member_form = built_member
      attempt_to_persist_and_route_member(benefit_app, @secondary_member_form)
    else
      @primary_member_form = built_member
      attempt_to_persist_and_route_member(benefit_app, @primary_member_form)
    end
  end

  def validate_application
    benefit_app = current_benefit_app

    if benefit_app&.primary_member.present?
      benefit_app.update(submitted_at: Date.today)
      redirect_to root_url
    else
      @members = current_members(benefit_app)
      @primary_member_form = benefit_app.build_primary_member
      render :new_member
    end
  end

  private

  def build_member(benefit_app)
    had_primary_member = benefit_app&.primary_member.present?

    if had_primary_member
      benefit_app.secondary_members.build(member_permitted_params)
    else
      benefit_app.build_primary_member(member_permitted_params)
    end
  end

  def attempt_to_persist_and_route_member(benefit_app, member_form)
    had_primary_member = benefit_app&.primary_member.present?

    if member_form.save && benefit_app.save
      redirect_to new_member_path
    else
      render :new_secondary_member if had_primary_member
      render :new_member unless had_primary_member
    end
  end

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

  def current_members(benefit_app)
    benefit_app.reload
    members = benefit_app.secondary_members.to_a
    members = [benefit_app.primary_member] + members if benefit_app.primary_member.present?
    members
  end
end

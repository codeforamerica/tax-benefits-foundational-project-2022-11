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
      redirect_to job_status_questions_path
      # redirect_to new_member_path
    else
      render :new
    end
  end

  def job_status_questions
    @benefit_app_form = current_benefit_app
    render :ask_job_status
  end

  def save_job_status
    @benefit_app_form = current_benefit_app
    if @benefit_app_form.update(benefits_permitted_params)
      if @benefit_app_form.has_job
        render :ask_income
      else
        redirect_to new_member_path
      end
    end
  end

  def update_income_info
    @benefit_app_form = current_benefit_app
    pay_schedule = job_income_permitted_params["pay_schedule"]
    income = job_income_permitted_params["income"].to_i
    monthly_income = (pay_schedule == "monthly" ? income : income * 2)

    if @benefit_app_form.update({monthly_income: monthly_income})
      render @benefit_app_form.eligible ? :inform_of_eligibility : :inform_of_ineligibilty
    else
      render :ask_income
    end
  end

  def delete_benefit_app
    @benefit_app = BenefitApp.find(params[:benefit_app_id])
    @benefit_app.destroy
    flash[:notice] = "The benefit app was successfully destroyed."
    redirect_to root_path
  end

  def edit_benefits_app
    @benefit_app_form = BenefitApp.find(params[:benefit_app_id])
    render :edit_benefits_app
  end

  def update_benefits_app
    @benefit_app_form = BenefitApp.find(params[:benefit_app_id])
    @members = current_members(@benefit_app_form)
    # @members = current_members(@benefit_app)

    if @benefit_app_form.update(benefits_permitted_params)
      flash[:success] = "Benefits app successfully updated!"
      redirect_to new_member_path, benefit_app_id: params[:benefit_app_id]
    else
      flash.now[:error] = "Failed to update benefits app"
      render :edit_benefits_app
    end
  end

  def new_member
    benefit_app = current_benefit_app
    @is_primary = benefit_app.primary_member.present?
    @members = current_members(benefit_app)
    if @is_primary
      @member_form = benefit_app&.secondary_members.build
      render :new_secondary_member
    else
      @member_form = benefit_app&.build_primary_member
      render :new_member
    end
  end

  def edit_member
    @member_form = Member.find(params[:id])
    render :edit_member
  end

  def update_member
    @member = Member.find(params[:id])
    if @member.update(member_permitted_params)
      flash[:success] = "Member successfully updated!"
      redirect_to new_member_path
    else
      flash.now[:error] = "Failed to update member"
      render :edit_member
    end
  end

  def create_member
    benefit_app = current_benefit_app
    @members = current_members(benefit_app)
    @member_form = build_member(benefit_app)
    save_member(benefit_app, @member_form)
  end

  def validate_application
    benefit_app = current_benefit_app

    if benefit_app&.primary_member.present?
      benefit_app.update(submitted_at: Date.today)
      redirect_to root_url
    else
      @members = current_members(benefit_app)
      @member_form = benefit_app.build_primary_member
      render :new_member
    end
  end

  def delete_member
    benefit_app = current_benefit_app
    member_id = params[:member_id].to_s.to_i
    @members = current_members(benefit_app)
    @member_form = benefit_app.secondary_members.build

    # If we don't recognize this member as a member ID, ignore.
    unless member_id.present? and member_id.in?(benefit_app.secondary_member_ids)
      flash.now[:error] = "The member was not found."
      return redirect_to members_path
    end

    # If the member isn't in the database, ignore.
    member = Member.find_by(id: member_id)
    if member.nil?
      flash.now[:error] = "The member was not found."
      return redirect_to members_path
    end

    member.destroy

    if member.destroyed?
      flash.now[:success] = "The member #{member.full_name} was removed."
      redirect_to new_member_path
    else
      flash[:error] = "Something went wrong when attempting to remove #{member.full_name}. Please try again."
      render :new_secondary_member
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

  def save_member(benefit_app, member_form)
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

  def job_income_permitted_params
    params.require(:benefit_app).permit(:pay_schedule, :income)
  end

  def benefits_permitted_params
    params.require(:benefit_app).permit(:email_address, :address, :phone_number, :has_job, :monthly_income)
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

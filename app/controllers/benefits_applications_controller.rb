class BenefitsApplicationsController < ApplicationController
  def index
    @apps = BenefitApp.all
  end

  def new
    @form = BenefitApp.new
  end
end

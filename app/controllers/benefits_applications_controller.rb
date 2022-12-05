class BenefitsApplicationsController < ApplicationController
  def index
    @apps = BenefitApp.all
  end

  def new
  end
end

require "rails_helper"

RSpec.describe BenefitsApplicationsController do
  controller do
    def index
      head :ok
    end
  end
end
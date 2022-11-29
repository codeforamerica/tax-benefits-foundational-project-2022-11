require 'rails_helper'
require 'spec_helper'

RSpec.describe "benefits_applications/index.html.erb", type: :view do
  it "shows the heading for listing submitted applications" do
    render
    expect(rendered).to match(/Submitted Applications/)
  end
  it "shows a way to add a new application" do
    render
    expect(rendered).to match(/New Application/)

  end
  # test "that the benefits application table view has the expected columns"
end

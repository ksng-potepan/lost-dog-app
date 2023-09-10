require 'rails_helper'

RSpec.describe "Homes" do
  describe "GET /top" do
    it "returns http success" do
      get "/home/top"
      expect(response).to have_http_status(:success)
    end
  end
end

RSpec.describe DatasourceController do
  describe "GET /" do
    it "should return 200 status" do
      get "/"
      expect(status).to eq([team])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end

require 'test_helper'

class DocumentsControllerTest < ActionController::TestCase
  test "adding a basic document" do
    post :create, format: :json
  end
end

require 'test_helper'

class TaxRatesControllerTest < ActionController::TestCase

  setup do
    setup_admin_session
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tax_rates)
  end

  test "should get new" do
    get :new
    assert_redirected_to tax_rates_path
  end

end

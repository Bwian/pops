require 'test_helper'

class TbrServiceTest < ActiveSupport::TestCase
  
  setup do
    @service = tbr_services(:both)
  end
  
  test "getters" do
    assert_equal "brian", @service.manager.code
    assert_equal "sean", @service.user.code
    assert_equal "0353321286", @service.code
    assert_equal "Dana Street Main Number", @service.name
    assert_equal "555", @service.cost_centre
    assert_equal "$5.00", @service.rental
    assert_equal "Telephone", @service.service_type
    assert_equal "Comment", @service.comment
  end
  
  test "manager_code" do
    assert_equal('brian',@service.manager_code)
    @service = tbr_services(:no_manager)
    assert_equal('Unassigned',@service.manager_code)
  end
  
  test "user_code" do
    assert_equal('sean',@service.user_code)
    @service = tbr_services(:no_user)
    assert_equal('Unassigned',@service.user_code)
  end
  
  test "service_types" do
    assert_equal(2,TbrService.service_types.count)
  end
end

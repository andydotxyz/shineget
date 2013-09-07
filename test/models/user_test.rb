require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save user without username" do
    user = User.new
    refute user.save, "Saved user without a username"
  end
end

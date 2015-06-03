require "test_helper"

describe User do
  describe "validation" do
    Given(:user) { users(:archer)  }
    Then { user.valid? }

    Then { !user.update(:hire_date => nil) }
    Then { !user.update(:location => nil) }
  end
end

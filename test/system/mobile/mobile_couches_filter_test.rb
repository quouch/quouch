# frozen_string_literal: true

require 'system_test_helper'

module Mobile
  class CouchesFilterTest < MobileSystemTestCase
    setup do
      @user = FactoryBot.create(:test_user_couch)
      sign_in_as(@user)
    end

    test 'should not see filters on initial load' do
      visit couches_path

      assert_selector 'div[data-display-filters-target="filters"]', visible: false
      find('.search__hide-filters').click
      assert_selector 'div[data-display-filters-target="filters"]', visible: true
    end
  end
end


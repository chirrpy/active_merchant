require 'test_helper'

# Test cards:
# MasterCard: 5000300020003003
#       Visa: 4005550000000019
#   Discover: 60011111111111117
#     Diners: 36999999999999
#       AMEX: 374255312721002

class RemotePayLeapTest < Test::Unit::TestCase
  
  def setup
    ActiveMerchant::Billing::Base.mode = :test
    @gateway = PayLeapGateway.new(fixtures(:payleap))
    
    @amount = 104
    @credit_card = ActiveMerchant::Billing::CreditCard.new(
        :type => "american_express",
        :number => "374255312721002",
        :verification_value => "123",
        :month => "10",
        :year => "2009",
        :first_name => "John",
        :last_name => "Doe"
    )

    @declined_card = ActiveMerchant::Billing::CreditCard.new(
        :type => "american_express",
        :number => "374255312721003",
        :verification_value => "123",
        :month => "10",
        :year => "2009",
        :first_name => "John",
        :last_name => "Doe"
    )
    
    @options = { 
      :order_id => '1',
      :billing_address => address,
      :description => 'Store Purchase'
    }
  end
  
  def test_successful_purchase
    assert response = @gateway.purchase(@amount, @credit_card, @options)
    assert_success response
    assert_equal 'Approved', response.message
  end

  def test_unsuccessful_purchase
    assert response = @gateway.purchase(@amount, @declined_card, @options)
    assert_failure response
    # assert_equal 'REPLACE WITH FAILED PURCHASE MESSAGE', response.message
  end

  def test_custom_login_and_password
    gateway = PayLeapGateway.new(
                :login => '',
                :password => '',
                :test => true
              )

    these_opts = @options.merge({:login => 'chirrpy-test_API', :password => 'Tj53PR71WophtU5V', :test => true})
    assert response = gateway.purchase(@amount, @credit_card, these_opts)
    assert_success response
  end

  def test_invalid_login
    gateway = PayLeapGateway.new(
                :login => '',
                :password => ''
              )
    assert response = gateway.purchase(@amount, @credit_card, @options)
    assert_failure response
#    assert_equal 'REPLACE WITH FAILURE MESSAGE', response.message
  end
end

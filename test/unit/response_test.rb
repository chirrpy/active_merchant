require 'test_helper'

class ResponseTest < Test::Unit::TestCase
  def test_response_invoice_number
    response = Response.new(true, 'message', :invoice_number => 'abc')

    assert_equal 'abc', response.invoice_number
  end

  def test_response_amount
    response = Response.new(true, 'message', :amount => 100)

    assert_equal 100, response.amount
  end

  def test_response_amount_when_not_specified
    response = Response.new(true, 'message', :param => 'value')

    assert_equal nil, response.amount
  end

  def test_raw_response
    response = Response.new(true, 'message', { :param => 'value' }, :raw_response => 'foo')

    assert_equal 'foo', response.raw_response
  end

  def test_response_success
    assert Response.new(true, 'message', :param => 'value').success?
    assert !Response.new(false, 'message', :param => 'value').success?
  end

  def test_get_params
    response = Response.new(true, 'message', :param => 'value')

    assert_equal ['param'], response.params.keys
  end

  def test_avs_result
    response = Response.new(true, 'message', {}, :avs_result => { :code => 'A', :street_match => 'Y', :zip_match => 'N' })
    avs_result = response.avs_result
    assert_equal 'A', avs_result['code']
    assert_equal AVSResult.messages['A'], avs_result['message']
  end

  def test_cvv_result
    response = Response.new(true, 'message', {}, :cvv_result => 'M')
    cvv_result = response.cvv_result
    assert_equal 'M', cvv_result['code']
    assert_equal CVVResult.messages['M'], cvv_result['message']
  end
end

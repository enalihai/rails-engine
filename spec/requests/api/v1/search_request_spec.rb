require 'rails_helper'

RSpec.describe 'Search API' do
  describe 'GET /items/find request' do
    it 'returns single item that matches search term'
    it 'allows to specify a name query parameter'
    it 'allows name: query parameter to be case insensitive'
    it '?min_price# should return equal to or greater than given price'
    it '?max_price# should return equal to or less than given price'
    it '?max_price=X&min_price=Y can use min and max price in query'
    it '?name=Name returns returns alphabetically'
    it 'allows to search by one or more price-related query parameters'
    it 'uses EITHER name param OR either/both price params'
    it 'uses BOTH name param AND either/both price params returns error'
  end

  describe 'GET /merchants/find request' do
    it 'single merchant that matches search term'
    it 'allows ?name which returns name and description'
    it 'allows ?name to be case insensitive'
    it '?name returns alphabetically'
  end

  describe 'GET /items/find_all request' do
    it 'items that match search term'
    it 'allows to specify a name query parameter'
    it 'allows name: query parameter to be case insensitive'
    it '?min_price# should return equal to or greater than given price'
    it '?max_price# should return equal to or less than given price'
    it '?max_price=X&min_price=Y can use min and max price in query'
    it '?name=Name returns all items alphabetically'
    it 'allows to search by one or more price-related query parameters'
    it 'uses EITHER name param OR either/both price params'
    it 'uses BOTH name param AND either/both price params returns error'
  end

  describe 'GET /merchants/find_all request' do
    it 'returns all merchants that match search term'
    it 'allows a name query parameter which returns name and description'
    it 'allows name: query parameter to be case insensitive'
    it '?name returns all matching merchants alphabetically'
  end
end

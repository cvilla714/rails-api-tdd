require 'rails_helper'

RSpec.describe '/articles route' do
  it 'routes to article#index' do
    # expect(get('/articles')).do route_to(controller: 'articles', action: 'index')
    aggregate_failures do
      expect(get('/articles')).to route_to('articles#index')
      #   expect(get('/articles?page[number]=3')).to route_to('articles#index', page: { 'number': 3 })
    end
  end
end

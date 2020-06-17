namespace :redeem do
  resources :redeem_products, only: [:index, :show]
  namespace :redeem_products do
    get 'admin_product', action: 'admin_product', as: 'admin_product'
  end

  namespace :redeem_transactions do
    post 'create_transaction', action: 'create_transaction', as: 'create_transaction'
    get 'company_product', action: 'company_product', as: 'company_product'
  end
end

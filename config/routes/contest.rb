namespace :contest do
  resource :contests

  namespace :contest do
    get "submit_contest", action: "submit_the_contest", as: "submit_contest"
  end
end


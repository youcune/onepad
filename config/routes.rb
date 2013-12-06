OnePad::Application.routes.draw do
  root 'pads#new'
  post 'create(.:format)' => 'pads#create', as: :create_pad
  get ':key(/:revision)(.:format)' => 'pads#show', as: :pad, constraints: { key: /\w{10}|\w{4}-\w{4}/, revision: /\d{4}-\d{4}-\d{4}/ }
  put ':key(.:format)' => 'pads#update', constraints: { key: /\w{10}|\w{4}-\w{4}/ }
  get ':key/history(.:format)' => 'pads#history', constraints: { key: /\w{10}|\w{4}-\w{4}/ }
end

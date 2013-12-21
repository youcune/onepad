OnePad::Application.routes.draw do
  root 'pads#new'
  get ':key(/:revision)(.:format)' => 'pads#show', as: :pad, constraints: { key: /\w{4}-\w{4}|\w{10}/, revision: /\d{4}-\d{4}-\d{4}/ }
  put ':key(.:format)' => 'pads#update', constraints: { key: /\w{4}-\w{4}|\w{10}/ }
end

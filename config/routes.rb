OnePad::Application.routes.draw do
  root controller: :pads, action: :new
  post 'create(.:format)', controller: :pads, action: :create, as: :create_pad
  get ':key(/:revision)(.:format)', controller: :pads, action: :show, as: :pad
  put ':key(.:format)', controller: :pads, action: :update
  get ':key/history(.:format)', controller: :pads, action: :history
end

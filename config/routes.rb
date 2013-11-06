OnePad::Application.routes.draw do
  root controller: :pads, action: :new
  get ':key(/:revision)(.:format)', controller: :pads, action: :show, as: :pad
  post 'new', controller: :pads, action: :create, as: :create_pad
  put ':key', controller: :pads, action: :update
  get ':key/history(.:format)', controller: :pads, action: :history
end

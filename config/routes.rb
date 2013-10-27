OnePad::Application.routes.draw do
  root controller: :pads, action: :new
  get ':key(/:revision)(.:format)', controller: :pads, action: :show, as: :pads_path
  post ':key', controller: :pads, action: :new
  put ':key', controller: :pads, action: :update
  get ':key/history(.:format)', controller: :pads, action: :history
end

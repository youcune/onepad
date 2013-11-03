# constants
VIEW_MODE = 1;
EDIT_MODE = 2
LOADED_STATUS = 1; # 開かれた状態
EDITED_STATUS = 2; # 開かれて編集された状態
SAVING_STATUS = 3; # 保存中の状態（LOADED_STATUS）
EDITED_ON_SAVING_STATUS = 4; # 保存中に編集された状態（保存完了したらEDITED_STATUSに遷移する）
STATUS = 1;
INTERVAL_SECONDS = 61; # 編集後、この時間が経過したら自動保存

# initialize
mode = VIEW_MODE;

# 表示モードに切り替え
switch_to_view_mode = ->
  $('div#body article').show();
  $('div#body form').hide();
  $('button#edit').show();
  $('button#history').hide();
  $('button#save').hide();
  $('button#ok').hide();
  mode = VIEW_MODE;

# 編集モードに切り替え
switch_to_edit_mode = ->
  $('div#body article').hide();
  $('div#body form').show();
  $('button#edit').hide();
  $('button#history').hide();
  $('button#save').show();
  $('button#ok').show();
  $('textarea#content-textarea').focus();
  mode = EDIT_MODE;

# 保存
save = (is_autosaved) ->
  alert(is_autosaved);
#  STATUS = SAVING_STATUS;
#  $.post(
#    '/' + PAD_JSON.key,
#    {
#
#    }
#  );
#  set_btn_status(2); // SAVING
#$.post(
#  ROOT_DIR + "/save.cgi",
#{
#  'pid' : $('#pid').val(),
#  'text' : $('#textarea').val(),
#  'action' : action
#},
#  function(json){
#    if(json.status == 0){
#    alert(json.message);
#}
#set_btn_status(json.status == 1 ? 3 : 4); // SAVED FAILED
#},
#'JSON'
#);

# initialize
$ ->
  switch_to_view_mode();
  $('button#edit').click -> switch_to_edit_mode();
  $('button#save').click -> save(true);
  $('button#ok').click ->
    save(true);
    switch_to_view_mode();

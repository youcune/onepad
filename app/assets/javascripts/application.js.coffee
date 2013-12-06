# constants
VIEWING = 1; # 編集が開始されていない状態
NEW = 2; # 新規作成されていない状態
LOADED = 3; # 編集が開始された状態
EDITED = 4; # 編集されたが保存されていない状態
SAVING = 5; # 保存中の状態（完了後はLOADEDに遷移）
EDITED_ON_SAVING = 6; # 保存中に編集された状態（保存完了したらEDITEDに遷移）
MAX_LENGTH = 1024;
INTERVAL_SECONDS = 61; # 編集後、この時間が経過したら自動保存
CLIENT_HEIGHT = 600;
STATUS = VIEWING; IS_CMD_DOWN = false; KEY = null;
$ARTICLE = null; $TEXTAREA = null;
$NOTIFICATION = null; $COUNT = null;
$GROUP_VIEW = null; $GROUP_EDIT = null;

# 表示モードに切り替え
switch_to_view_mode = ->
  $GROUP_VIEW.show();
  $GROUP_EDIT.hide();
  if STATUS == NEW
    notify('info', '下にある<span class="icon-edit"></span>ボタンを押すとすぐにメモの編集を始められます！', 5);
  else
    STATUS = VIEWING;

# 編集モードに切り替え
switch_to_edit_mode = ->
  $GROUP_VIEW.hide();
  $GROUP_EDIT.show();
  if STATUS == NEW
    notify('info', '保存するには<span class="icon-save"></span>、保存して終了するには<span class="icon-ok"></span>を押してくださいね！', 8);
  else
    STATUS = LOADED;

# テキストエリアで編集中
textarea_focus = ->
  if "ontouchend" in window
    $TEXTAREA.css('height', (CLIENT_HEIGHT - 81) * 0.45);
    $(window).scrollTop(32);

# テキストエリアで編集終了
textarea_blur = ->
  $TEXTAREA.css('height', CLIENT_HEIGHT - 81);

# 残り文字数を計算
calc_count = ->
  rest = MAX_LENGTH - $TEXTAREA.val().length;
  $COUNT.text(rest);
  if(rest < 100)
    $COUNT.addClass('warning');
  else
    $COUNT.removeClass('warning');

# APIの応答を画面にマップする
append_content = (json, updates_textarea) ->
  $ARTICLE.html(json.html);
  if updates_textarea
    $TEXTAREA.val(json.content);

# 開く
select = ->
  $.get('/' + KEY + '.json')
    .done (json) ->
      append_content(json, true);
      notify('success', 'よみこみました！', 2);

# 作成
insert = ->
  STATUS = SAVING;
  notify('warning', '作成中...', 0);
  $.post(
    '/create.json',
  {
    '_method': 'POST',
    'content': $TEXTAREA.val()
  }
  ).done (json) ->
    append_content(json, false);

    if window.history && window.history.pushState
      window.history.pushState("", "" , '/' + json.key);
    else
      location.href = '/' + json.key
    notify('success', '作成しました！　このURLをいろんな端末にブックマークしよう！', 5);
    STATUS = LOADED;
    KEY = json.key
  .fail (e) ->
      STATUS = NEW;
      notify('danger', '作成できませんでした！', 0);

# 保存
update = (is_autosaved, is_completed) ->
  if STATUS == EDITED || STATUS == EDITED_ON_SAVING || STATUS == SAVING
    STATUS = SAVING;
    notify('warning', '保存中...', 0);
    $.post(
      '/' + KEY + '.json',
      {
        '_method': 'PUT',
        'content': $TEXTAREA.val(),
        'is_autosaved': is_autosaved
      }
    ).done (json) ->
      append_content(json, false);
      notify('success', '保存しました！', 2);
      if is_completed
        switch_to_view_mode();
      else
        STATUS = if STATUS == EDITED_ON_SAVING then EDITED else LOADED;
    .fail (e) ->
      STATUS = EDITED;
      notify('danger', '保存できませんでした！', 0);
  else if is_completed
    notify('info', '編集するのをやめるんですね、了解です！', 5);
    switch_to_view_mode();
  else
    notify('danger', '変更されていません！', 2);

# insertかupdateかを判断して保存する
save = (is_autosaved, is_completed) ->
  if STATUS == NEW
    insert();
  else
    update(is_autosaved, is_completed);

keyup = ->
  IS_CMD_DOWN = false; # どのキーが離されてもcommandキーを解放
  calc_count();
  if STATUS != NEW
    STATUS = if STATUS == SAVING then EDITED_ON_SAVING else EDITED;

notify = (type, message, timer) ->
  $('#notification')
    .removeClass()
    .addClass('alert')
    .addClass('alert-' + type)
    .html(message)
    .fadeIn('fast');
  if timer > 0
    setTimeout (-> hide_notification()), timer * 1000;

hide_notification = ->
  $('#notification').fadeOut('fast');

# initialize
$ ->
  KEY = $('input#key').val();
  CLIENT_HEIGHT = $('html').prop('clientHeight');
  $ARTICLE = $('article#content-article').css('height', CLIENT_HEIGHT - 81);
  $TEXTAREA = $('textarea#content-textarea').css('height', CLIENT_HEIGHT - 81);
  $NOTIFICATION = $('div#notification');
  $COUNT = $('input#count');
  $GROUP_VIEW = $('.group-view');
  $GROUP_EDIT = $('.group-edit');
  if KEY == 'create'
    STATUS = NEW;
  else
    select();
  calc_count();
  switch_to_view_mode();
  $TEXTAREA.focus -> textarea_focus();
  $TEXTAREA.blur -> textarea_blur();
  $('button#edit').click -> switch_to_edit_mode();
  $('button#save').click -> save(false, false);
  $('button#ok').click -> save(false, true);
  $TEXTAREA.keyup -> keyup();

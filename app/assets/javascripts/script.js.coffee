# constants
VIEW_MODE = 1
EDIT_MODE = 2
LOADED_STATUS = 1 # 開かれた状態
EDITED_STATUS = 2 # 開かれて編集された状態
SAVING_STATUS = 3 # 保存中の状態（LOADED_STATUS）
EDITED_ON_SAVING_STATUS = 4 # 保存中に編集された状態（保存完了したらEDITED_STATUSに遷移する）
INTERVAL_SECONDS = 61 # 編集後、この時間が経過したら自動保存

# 表示モードに切り替え
switch_to_view_mode = ->
  alert(json.content);

# 起動直後
$ ->
  switch_to_view_mode();
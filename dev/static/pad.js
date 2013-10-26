// -------------------------------------------------------------------
// OnePad Javascript for Editing Pad
// -------------------------------------------------------------------

// 初期化
is_cmd_down = false;	// commandキーがdown状態にあるか
is_saved    = true;		// 最新のデータがサーバに保存されているか

$(function(){
	// 初期化
	init();
	setInterval(minute_job, 60000);
	$(window).resize(window_resize);
	$('#textdiv').mouseover(textdiv_mouseover);
	$('#textdiv').mouseout(textdiv_mouseout);
	$('#textdiv').click(textdiv_click);
	$('#textarea').blur(textarea_blur);
	$('#textarea').keydown(textarea_keydown);
	$('#textarea').keyup(textarea_keyup);
	$('#save').click(save_click);
	$('#load').click(load_click);
});

// 初期化
function init(){
	// オンラインならキャッシュの更新を確認
	cache = window.applicationCache;
	cache.addEventListener("updateready", function() {
		cache.swapCache();
		location.reload();
	});
	if (cache.status != cache.UNCACHED && navigator.onLine) {
		cache.update();
	}
	
	$('#textarea').hide();
	$('#textdiv').show();
	window_resize();
	set_btn_status(1);
	load();
}

// 1分おきに自動保存
function minute_job(){
	if(!is_saved){
		setTimeout("save('A')", 100);
	}
}

// 画面上下のバーを除く範囲いっぱいに拡大
function window_resize(){
}

// 編集ができるように見せる
function textdiv_mouseover(e){
	if($(e.target).is('div')){
		$('#textdiv').addClass('editable');
	}
}

// 編集ができるように見せるのをやめる
function textdiv_mouseout(e){
	$('#textdiv').removeClass('editable');
}

// 編集開始
function textdiv_click(e){
	if($(e.target).is('div')){
		var h = $('html').prop('clientHeight') - 83;	// 基準となる高さ
		$('#textdiv').hide();
		$('#textarea').show().focus();
		if("ontouchend" in window){
			// タッチパネル端末の場合、ソフトウェアキーボードを考慮した高さにする
			$('#textarea').height(h *= 0.4);
			$(window).scrollTop(32);
		}
		else{
			$('#textarea').height(h);
		}
	}
}

// 編集終了
function textarea_blur(e){
	setTimeout(function(){
		build_textdiv();
		$('#textarea').hide();
		$('#textdiv').removeClass('editable').show();
		$(window).scrollTop($('#save').offset().top);
	}, 200);
}

// キーボードが押されたとき
function textarea_keydown(e){
	if(e.which == 224 || e.which == 17){ // command or control
		is_cmd_down = true;
	}
	else{
		if(is_cmd_down && e.which == 83){ // S
			e.returnvalue = false;
			setTimeout("save('M')", 100);
			return false;
		}
	}
}

// キーボードが離されたとき
function textarea_keyup(e){
	is_cmd_down = false;	// どのキーが離されてもcommandキーを解放する
	is_saved    = false;	// 変更された
	calc_count();
}

// SAVEボタンが押されたとき
function save_click(e){
	save("M");
	return false;
}

// LOADボタンが押されたとき
function load_click(e){
	location.href = ROOT_DIR + "/" + $('#pid').val() + "/history";
	return false;
}

// AjaxでOnePadの内容をPOSTする
function save(action){
	if($('#textarea').val().length <= 1024 || confirm('長すぎるので保存すると最後の方が切れます')){
		set_btn_status(2); // SAVING
		$.post(
			ROOT_DIR + "/save.cgi", 
			{
				'pid' : $('#pid').val(), 
				'text' : $('#textarea').val(), 
				'action' : action
			}, 
			function(json){
				if(json.status == 0){
					alert(json.message);
				}
				set_btn_status(json.status == 1 ? 3 : 4); // SAVED FAILED
			},
			'JSON'
		);
	}
}

// AjaxでOnePadの内容を読み込む
function load(){
		$.getJSON(
			ROOT_DIR + "/load.cgi", 
			{ 'pid' : $('#pid').val() }, 
			function(json){
				if(json.status == 0){
					alert(json.message);
				}
				$('#textarea').val(json.pads[0].text);
				build_textdiv();
				calc_count();
			}
		);
}

// textareaの内容をtextdivにコピーする
function build_textdiv(){
	var text;
	
	if($('#textarea').val().length == 0){
		text = '<span style="color: #999999;">なにもありません</span><br><br>';
	}
	else{
		text = $('#textarea').val()
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;')
			.replace(/"/g, '&quot;') // "
			.replace(/ /g, '&nbsp;')
			.replace(/^(https?:\/\/[\w\/\.\+\-\=\%\?\&\;]+)/gm, '<a href="$1">$1</a>')
			.replace(/^([\w\/\.\+\-\=\%\?\&\;]+\@[\w\/\.\+\-\=\%\?\&\;]+\.[\w\/\.\+\-\=\%\?\&\;]+)/gm, '<a href="mailto:$1">$1</a>')
			.replace(/^(0[\d-]{9,15})/gm, '<a href="tel:$1">$1</a>')
			.replace(/^((北海道|青森県|岩手県|宮城県|秋田県|山形県|福島県|茨城県|栃木県|群馬県|埼玉県|千葉県|東京都|神奈川県|新潟県|富山県|石川県|福井県|山梨県|長野県|岐阜県|静岡県|愛知県|三重県|滋賀県|京都府|大阪府|兵庫県|奈良県|和歌山県|鳥取県|島根県|岡山県|広島県|山口県|徳島県|香川県|愛媛県|高知県|福岡県|佐賀県|長崎県|熊本県|大分県|宮崎県|鹿児島県|沖縄県)[^<]{5,})/gm, '<a href="http://maps.google.com/maps?hl=ja&q='+encodeURI("$1")+'">$1</a>')
			.replace(/\n/g, '<br>')
			+ '<br><br>';
	}
	$('#textdiv').html(text);
}

// 残りの文字数を数える
function calc_count(){
	var rest = 1024 - $('#textarea').val().length;
	$('#count').text(rest);
	if(rest < 100){
		$('#count').addClass('warning');
	}
	else{
		$('#count').removeClass('warning');
	}
}

// Ajaxの通信状態によってボタンの見た目を変える
function set_btn_status(status){
	// 1: SAVE, 2: SAVING, 3:SAVED, 4:FAILED
	if(status == 1){
		$('#save').text('SAVE').attr('class', 'active');
	}
	else if(status == 2){
		$('#save').text('SAVING').attr('class', 'inactive');
	}
	else if(status == 3){
		$('#save').text('SAVED!').attr('class', 'active');
		setTimeout(function(){ set_btn_status(1); }, 3000);
		is_saved = true;
	}
	else if(status == 4){
		$('#save').text('FAILED!').attr('class', 'error');
	}
}

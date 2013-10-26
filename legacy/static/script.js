// 初期化
command_key = false;
$(function(){
	page_setup();
	if($('#count')){ update_count(); }
	if($('#save')) { set_save_status(1); } // SAVE
	$(window).resize(function(){ page_setup(); });
	$('#text').keydown(function(e){
		if(e.which == 224 || e.which == 17){ // command or control
			command_key = true;
		}
		else{
			if(command_key && e.which == 83){ // S
				e.returnvalue = false;
				setTimeout('update_pad();', 100);
				return false;
			}
		}
	});
	$('#text').keyup(function(e){
			command_key = false;
	});
});

// AjaxでOnePadの内容をPOSTする
function update_pad(){
		if($('#text').val().length <= 1024 || confirm('長すぎるので保存すると最後の方が切れます')){
			set_save_status(2); // SAVING
			jQuery.post(
				'/save.cgi', 
				{
					'pid' : $('#pid').val(), 
					'text' : $('#text').val(), 
					'action' : 'M'
				}, 
				function(json){
					set_save_status(json.status == 1 ? 3 : 4); // SAVED FAILED
				},
				'JSON'
			);
		}
}

// 画面上下のバーを除く範囲いっぱいに拡大
function page_setup(){
	var height = $('html').prop('clientHeight');
	if($('#links')){
		$('#container').height(height - 81 - $('#links').height());
	}
	else{
		$('#container').height(height - 81);
	}
}

// 残りの文字数を描画する
function update_count(){
	var rest = 1024 - $('#text').val().length;
	$('#count').text(rest);
	if(rest < 100){
		$('#count').addClass('warning');
	}
	else{
		$('#count').removeClass('warning');
	}
}

// Ajaxの通信状態によってボタンの見た目を変える
function set_save_status(status){
	// 1: SAVE, 2: SAVING, 3:SAVED, 4:FAILED
	if(status == 1){
		$('#save').text('SAVE').attr('class', 'active');
	}
	else if(status == 2){
		$('#save').text('SAVING').attr('class', 'inactive');
	}
	else if(status == 3){
		$('#save').text('SAVED!').attr('class', 'active');
		setTimeout(function(){ set_save_status(1); }, 3000);
	}
	else if(status == 4){
		$('#save').text('FAILED!').attr('class', 'error');
	}
}

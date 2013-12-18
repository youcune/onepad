class PadsController < ApplicationController
  DEFAULT_CONTENT = <<-'END_OF_CONTENT'
# OnePadへようこそ！
## OnePadとは？
OnePadは、会員登録不要で1ページだけ作れる1024字までのクラウドメモサービスです。同じURLを携帯でもブックマークすることで、同じメモが見れます。これまでメールで送っていた手間が省けます。もちろん無料です！

OnePad2になり、[Markdown](http://ja.wikipedia.org/wiki/Markdown)が使えるようになりました！　文書の先頭が # から始まる場合はMarkdownモードになります！

各種お問い合せは [webmaster@anone.me](mailto:webmaster@anone.me) まで！

## 利用規定
* OnePad運営者（以下、甲）はサービス利用者（以下、乙）に対して何があってもいかなる保証もしません。
* 90日更新のないメモは削除されることがあります。
* この利用規定は予告なく加筆変更することがあります。
  END_OF_CONTENT

  # GET /
  def new
    @pad = Pad.new(key: 'create', content: DEFAULT_CONTENT)
    render action: :show
  end

  # POST /create.json
  def create
    @pad = Pad.new(content: params[:content])

    begin
      if @pad.smarter_save
        render action: :show, status: :created
      else
        render json: { errors: @pad.errors.full_messages }, status: :bad_request
      end
    rescue RetryableError => e
      render json: { errors: [e.message] }, status: e.status
    rescue
      render json: { errors: ['サーバ内部エラー'] }, status: :internal_server_error
    end
  end

  # GET /:key
  # GET /:key.json
  # GET /:key/:revision
  # GET /:key/:revision.json
  def show
    @pad = params[:revision].nil? ? Pad.find_latest(params[:key]) : Pad.find_one(params[:key], params[:revision])

    if @pad.nil?
      if params[:format].to_sym == :json
        render json: { errors: ['指定のメモが見つかりませんでした'] }, status: :not_found
      else
        flash[:alert] = '指定のメモが見つかりませんでした'
        redirect_to action: :new
      end
    end
  end

  # PATCH/PUT /:key
  # PATCH/PUT /:key.json
  def update
    @pad = Pad.new(pad_params)

    if @pad.smarter_save
      render action: 'show', status: :ok
    elsif @pad.errors.present?
      render json: { errors: @pad.errors.full_messages }, status: :bad_request
    else
      render status: :internal_server_error
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def pad_params
      params.permit(:key, :content, :is_autosaved)
    end
end

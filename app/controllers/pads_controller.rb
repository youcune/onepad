class PadsController < ApplicationController
  # GET /:key
  # GET /:key.json
  # GET /:key/:revision
  # GET /:key/:revision.json
  def show
    @pad = params[:revision].nil? ? Pad.find_latest(params[:key]) : Pad.find_one(params[:key], params[:revision])
  end

  # POST /pads
  # POST /pads.json
  def create
    # TODO
    @pad = Pad.new(pad_params)

    respond_to do |format|
      if @pad.save
        format.html { redirect_to @pad, notice: 'Pad was successfully created.' }
        format.json { render action: 'show', status: :created, location: @pad }
      else
        format.html { render action: 'new' }
        format.json { render json: @pad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pads/1
  # PATCH/PUT /pads/1.json
  def update
    respond_to do |format|
      byebug
      if Pad.save(params[:key], params[:content], params[:is_autosaved] == 'true')
        format.html { redirect_to @pad, notice: 'Pad was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pad.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def pad_params
      params.require(:pad).permit(:key, :content, :is_autosaved)
    end
end

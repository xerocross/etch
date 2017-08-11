class KeywordsController < ApplicationController
  before_action :authenticate
  before_action :set_keyword, only: [:show, :edit, :update, :destroy]
  

  # GET /keywords
  # GET /keywords.json
  def index
    @back = etch_options_path
    @keywords = @user.keywords
    @params = params
    if params[:flashcard_id].present?
      flashcard = Flashcard.find(params[:flashcard_id])
      if !flashcard.nil?
        @keywords = @keywords.merge(flashcard.keywords)
      end
    end
  end

  def new
    @keyword = Keyword.new
  end

  # GET /keywords/1/edit
  def edit
    @back = keywords_path
  end

  # POST /keywords
  # POST /keywords.json
  def create
    puts params.inspect
    @keyword = Keyword.new(keyword_params)
    @keyword.user = @user
    respond_to do |format|
      if @keyword.save
        format.html { redirect_to @keyword, notice: 'Keyword was successfully created.' }
        format.json { render :show }
      else
        format.html { render :new }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @keyword.update(keyword_params)
        format.html { redirect_to keywords_path, notice: 'Keyword was successfully updated.' }
        format.json { render :show, status: :ok, location: @keyword }
      else
        format.html { render :edit }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /keywords/1
  # DELETE /keywords/1.json
  def destroy
    @keyword.destroy
    respond_to do |format|
      format.html { redirect_to keywords_url, notice: 'Keyword was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_keyword
      @keyword = @user.keywords.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def keyword_params
      params.require(:keyword).permit(:text)
    end
end

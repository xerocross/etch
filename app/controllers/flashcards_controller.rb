class FlashcardsController < ApplicationController
  before_action :authenticate
  before_action :initialize_flashcards, except: [:create, :new, :destroy]
  before_action :set_flashcard, only: [:show, :edit, :update, :destroy, :got_it, :too_soon, :too_late, :set_flashcard_reviewed]
  

  def show
    @back = flashcards_manager_path
  end
  
  
  def index
    
    @back = flashcards_manager_path
    getFlashcards(params)
    @perPage = 30
    
    @totalNum = @flashcards.length
    
    if request.format.html?
      @flashcards = @flashcards.paginate(page: params[:page], per_page: @perPage)
    elsif request.format.json?
      if !params[:no_paginate].present?
        
        @flashcards = @flashcards.paginate(page: params[:page], per_page: @perPage)
      end
    end
  end
  
  def memorize
    @title = 'Memorize'
    @path = flashcards_path(format: :json, params: {'memorize'=> true})
    render 'review'
  end
  
  def review
    @title = 'Review'
    @path = flashcards_path(format: :json,params:{'review'=> true})
    @tip = @reviewTip
    render 'review'
  end
  
  def study_by_keywords
    @title = 'Study by Keywords'
    @path = flashcards_path(format: :json,params:{'keywords'=> params[:keywords]})
    render 'review'
  end
  

  #patch
  def got_it
    @flashcard.got_it
    @flashcard.compute_due
    @flashcard.save!
    render json: {method: 'got_it'}
  end

  
  def edit
    @back = flashcards_manager_manage_path
    if !@flashcard.macro.nil?
      @macro = @flashcard.macro
    else
      @macro = 'custom'
    end
    render 'flashcards_manager/edit'
  end
  

  def too_late
    @flashcard.too_late
    @flashcard.compute_due
    @flashcard.save!
    # a card was found due too late
  end
    
  def too_soon
  # a card was found due too early
    @flashcard.too_soon
    @flashcard.compute_due
    @flashcard.save!
  end
    
  # GET /flashcards/new
  
  def new
    @back = flashcards_manager_path
    if params[:macro].present?
      macros.any? do |m|
        if m == params[:macro]
          @macro = params[:macro]
        else
          puts "false"
        end
      end
    end
    session[:macro] = new_flashcard_path({macro: @macro.to_s})
    @tip = @newFlashcardTip
    init_new
  end

  def fill_in_the_blank
    session[:macro] = fill_in_the_blank_flashcards_path
    init_new
  end
  
  def foreign_vocab
    session[:macro] = foreign_vocab_flashcards_path
    init_new
  end
  
  def create
    @flashcard = Flashcard.new(flashcard_params)
    @flashcard.user = @user
    if @flashcard.still_learning.nil?
      @flashcard.still_learning = true
    end
    if @flashcard.due_model.nil?
      @flashcard.due_model = 1
    end
    @macro = !params['flashcard']['macro'].nil? ? params['flashcard']['macro'] : 'custom'
    update_keywords
    
    if @flashcard.keywords.any?
      keyword_id_array = Keyword.id_array(@flashcard.keywords)
    else
      keyword_id_array = []
    end
    
    respond_to do |format|
      if @flashcard.save
        format.html { redirect_to flashcards_manager_new_path('macro'=>@macro,'keywords' =>keyword_id_array.to_s), notice: 'Flashcard was successfully created.' }
        format.json{ render status: 200, json: {success: true}}
      else
        format.html {render flashcards_manager_new_path, alert: 'Could not save.  See below.',location: new_flashcard_path}
        format.json{ render status: 422, json: {success: false}}
      end
    end
    update_reviews
  end

  def update
    update_keywords
    # :keyword_string
    respond_to do |format|
      if @flashcard.update(flashcard_params)
        format.html { redirect_to @flashcard, notice: 'Flashcard was successfully updated.' }
        format.json { render :show, status: :ok, location: @flashcard }
      else
        format.html { render :edit }
        format.json { render json: @flashcard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flashcards/1
  # DELETE /flashcards/1.json
  def destroy
    @flashcard.destroy
    respond_to do |format|
      format.html { redirect_to flashcards_url, notice: 'Flashcard was successfully destroyed.' }
      format.json {render json: {"notice"=>'Flashcard was successfully destroyed.'}}
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    
    def macros
      ['custom', 'foreign_vocab', 'fill_blank','multi_choice']
    end
    
    def update_reviews
      if params[:flashcard].has_key?(:updates)
        updates = params[:flashcard][:updates]
        updates.each do |u|
          @flashcard.add_review(u)
        end
      end
    end
    
    
    def get_num_updates(flashcard)
      updates_array = flashcard.updates
      num_updates = updates_array.length
    end
    

    def get_next_review_date(flashcard)
      num_updates = get_num_updates(flashcard)
      gap = get_cooling_period(num_updates);
      review_date = Date.today + gap
      review_date_string = review_date.strftime("%Y-%m-%d")
    end
    
    def query_form
      @keywords = @user.Keywords
    end
  
    def update_keywords
      if params.has_key?(:keyword_string)
          @flashcard.keywords.clear
          keywords_from_client = JSON.parse(params[:keyword_string])
          @working_keywords = []
          keywords_from_client.each do |key_input|
            if !key_input['id'].nil?
              existing_keyword = @user.keywords.find(key_input['id'])
              @working_keywords.push existing_keyword
            elsif !key_input['text'].nil?
              new_keyword = Keyword.create(text: key_input['text'], user_id: @user.id)
              @working_keywords.push new_keyword
            else
              puts key_input
            end
          
          end
          @flashcard.keywords.concat @working_keywords
      end
    end
  
    def set_flashcard
      @flashcard = @user.flashcards.find(params[:id])
    end

    def initialize_flashcards
      @flashcards = @user.flashcards.order(id: :desc)
      @keywords = @user.keywords
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flashcard_params
      params.require(:flashcard).permit(:front_side, :back_side, :date_repetition_due, :data, :macro)
    end
    
    
    def init_tips
      @slap = ""
      @@reviewTips = [1, 2]
      index = 0
      @reviewTip = Tip.find @@reviewTips[index]
      @slap += "#{@user.tips.include? @reviewTip} : #{index} :  right #{index < @@reviewTips.length}  :length  #{@@reviewTips.length} condition: #{@user.tips.include? @reviewTip && index < @@reviewTips.length}"
      while @user.tips.include?(@reviewTip) && index < @@reviewTips.length - 1 do
        @slap += "a"
        puts "index: #{index}"
        index += 1
        @reviewTip = Tip.find @@reviewTips[index]
      end
      
      @@newFlashcardTips = [3]
      index = 0
      @newFlashcardTip = Tip.find @@newFlashcardTips[index]
      while @user.tips.include?(@newFlashcardTip) && index < @@newFlashcardTips.length - 1 do
        index += 1
        @newFlashcardTip = Tip.find @@newFlashcardTips[index]
      end
      
    end
    
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  attr_accessor :username
  before_action :init_vars

  def init_vars
  end

  def authenticate
      if !user_signed_in?
        respond_to do |format|
          format.html { redirect_to account_log_in_path}
          format.json { render json: {success: false} }
        end
      else
          @user = current_user
      end
  end
  
  def excerpt(text)
      puts text
      $returnString = ""
      $wordArray = text.split(" ")
      puts $wordArray
      $wordIndex = 0
      while $wordIndex < $wordArray.length and $returnString.length < 50 do
        $returnString << $wordArray[$wordIndex].to_s << " "
        $wordIndex += 1
      end
      if $returnString.length > 55
        $returnString = $returnString[0,50]
      end
      $returnString
   end
  
  def getFlashcards(params)
    @flashcards = @user.flashcards.order(:id)
    
    @flashcards = @flashcards.due.where.not(still_learning: true) if params[:review].present?
    @flashcards = @flashcards.still_learning if params[:memorize].present?
    if params[:key].present?
        keyword = Keyword.find_by_id(params[:key])
        @flashcards.merge!(keyword.flashcards) if !keyword.nil?
    end
    if params[:keyword].present?
        keyword = Keyword.find_by_text(params[:keyword])
        @flashcards.merge!(keyword.flashcards) if !keyword.nil?
    end

    if params[:cardIds].present?
      cardIdList = JSON.parse(params[:cardIds])
      @flashcards = @flashcards.where(id: cardIdList)
      puts @flashcards
    end
    
    if params[:keywords].present?
      @flashcards = @flashcards.to_a
      keywordList = JSON.parse(params[:keywords]) #expecting array of ids
      @keywords = []
      keywordList.each do |id|
        keyword = @user.keywords.find(id)
        @keywords.push keyword if !keyword.nil?
      end
      @keywords.each do |keyword|
        @flashcards = @flashcards & keyword.flashcards
      end
      
      
      if params[:keywords_strict].present?
        deleteThese = []
        @flashcards.each do |f|
          puts "and it has #{@flashcards.size} elements"
          ids = @flashcards.pluck :id
          puts ids.to_s
          puts "checking #{f.id}"
          puts "f keywords attached: #{f.keywords.size}"
          puts "and @keywords.size: is #{@keywords.size}"
          if f.keywords.size > @keywords.size
            deleteThese.push f
          else
            puts "not deleting #{f.id}"
          end
        end
        deleteThese.each do |f|
          @flashcards.delete f
        end
      end
      
      
      
      
      @flashcards.sort! {|left, right| right.id <=> left.id}
    

    end
    @flashcards
  end
end

class FlashcardsManagerController < ApplicationController
  before_action :authenticate
  before_action :set_back_link
  
  def options
    @back = etch_options_path
  end

  def export
    @flashcards = getFlashcards(params)
  end
  
  
  def new
    @back
    if !params[:macro].present?
      redirect_to flashcards_manager_choose_creation_macro_path
      @back = flashcards_manager_path
    elsif params[:macro].present?
      @back = flashcards_manager_choose_creation_macro_path
      macros.any? do |m|
        if m == params[:macro]
          @macro = params[:macro]
        else
          puts "false"
        end
      end

      session[:macro] = flashcards_manager_new_path({macro: @macro.to_s})
      init_new
    end
  end

  private
  
  def set_back_link
    @back = flashcards_manager_path
  end
  
  def macros
    ['custom', 'foreign_vocab', 'fill_blank','multi_choice']
  end
  
  def init_new
    @flashcard = Flashcard.new
    if params[:keywords].present?
      @flashcard.keywords.concat Keyword.find(JSON.parse(params[:keywords]))
    end
  end
  
end

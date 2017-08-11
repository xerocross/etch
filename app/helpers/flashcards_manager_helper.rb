module FlashcardsManagerHelper

def macro_title(macro)
    case macro
    when 'multi_choice'
      "Multiple Choice"
    when 'foreign_vocab'
      "Foreign Word"
    when 'custom'
      "Custom"
    when 'fill_blank'
      "Fill In the Blank"
    end
  end

end

module FlashcardsHelper

  
  def submit_button(f)
    f.submit :class =>'btn btn-lg btn-success action'
  end


  
  
  def process_button_glyph(method)
    if method == :got_it
      'glyphicon glyphicon-ok'
    elsif method == :too_late
      'glyphicon glyphicon-flash'
    elsif method == :too_soon
      'don'
    end
  end


end

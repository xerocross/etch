

module ApplicationHelper
  
  
  def back_link(controller, action_name)

    
  end
  
  
  def icon(controller_name)
    case controller_name
    when 'keywords'
      '<i class="fa fa-magnet" aria-hidden="true"></i>'
    when 'flashcards_manager'
      '<i class="fa fa-database" aria-hidden="true"></i>'
    when 'flashcards'
      '<i class="fa fa-database" aria-hidden="true"></i>'
    when 'study'
      '<i class="fa fa-book" aria-hidden="true"></i>'
    when 'accounts'
      '<i class="fa fa-user" aria-hidden="true"></i>'
    end
  end
  
  
  def title(controller_name)
    case controller_name
    when 'accounts'
      icon('accounts')
    when 'study'
      icon('study')
    when 'accounts'
      icon('accounts')
    when 'keywords'
      icon('keywords')
    when 'sessions'
      icon('accounts')
    when 'registrations'
      icon('accounts')
    when 'flashcards_manager'
      icon('flashcards_manager')
    when 'flashcards'
      icon('flashcards_manager')
    when 'etch'
      '<span class="masthead">Etch#</span>'
    else
      controller_name.titlecase
    end
  end
  
  
  def title(controller_name, action_name)
    action_name_disp = case action_name
    when 'options'
      ""
    when 'choose_creation_macro'
      'new'
    when 'show'
      'view'
    when 'contact_us'
      'contact'
    when 'query'
      'select cards'
    when 'browse'
      'by keyword'
    when 'welcome'
      ''
    else
      "#{action_name}"
    end
    
    controller_name_disp = case controller_name
    when 'accounts'
      '<i class="fa fa-user" aria-hidden="true"></i>'
    when 'study'
      icon('study')
    when 'accounts'
      icon('accounts')
    when 'keywords'
      icon('keywords')
    when 'sessions'
      if action_name == 'new'
        action_name_disp = 'login'
      end
      '<i class="fa fa-user" aria-hidden="true"></i>'
    when 'registrations'
      '<i class="fa fa-user" aria-hidden="true"></i>'
    when 'flashcards_manager'
      icon('flashcards_manager')
    when 'flashcards'
      icon('flashcards_manager')
    when 'brains'
      '<i class="fa fa-sliders" aria-hidden="true"></i>'
    when 'etch'
      '<span class="masthead">Etch#</span>'
    else
      controller_name.titlecase
    end
    
    if controller_name == 'registrations' && action_name == 'new'
      action_name_disp = 'register'
    end
    
    
    if action_name_disp.length > 0
      str = "#{controller_name_disp} #{action_name_disp}"
    else
      str = "#{controller_name_disp}"
    end
    if !@flashcard.nil? && !@flashcard.id.nil?
      str += "?#{@flashcard.id}"
    end
    str
  end
  
  def logged_in?
    if session[:user_id].nil? then
      false
    else
      true
    end
  end
  
  
  def bootstrap_js_link
    "<script src=\"//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js\" integrity=\"sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa\" crossorigin=\"anonymous\"></script>".html_safe
  end
  
  def bootstrap_css_link
    '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">'.html_safe
  end
  
  
  
  
  def include_tip(tip)
    if tip.nil?
      return
    end
  
    if tip.class.name == "String"
      tip = Tip.where(description: tip).first
    end
    
    
    tag = "<div ng-controller='alert'   class='alert alert-info alert-dismissible tip' role='alert'><button ng-click='setSeen(#{tip.id})' type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button>#{tip.text}</div>".html_safe
    if !@user.tips.where(id: tip.id).exists?
      tag
    else
      ""
    end
  end
end

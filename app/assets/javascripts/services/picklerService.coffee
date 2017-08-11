cardPicklerService = (cardModel)->
  PICKLE_VERSION = 0.1;
  TAB = "   ";
  
  getPackedTags = (tags)->
    packedTags = [];
    for keywordObj in tags
      keywordText = keywordObj.text
      keywordText = keywordText.replace(/-/g,"_")
      keywordText = keywordText.replace(/[^a-zA-Z0-9_]/g,"")
      keywordText = "#" + keywordText
      packedTags.push(keywordText)
    packedTags;
    
  unpackTags = (packedTags)->
    tags = []
    for tag in packedTags
      tag = tag.replace(/_/g,"-")
      tags.push tag.substring(1)
    tags
    
  genExportText = (pickledCard, card)->
    VERSION = 0.1
    exportText = "{\n"
    exportText+= "#{TAB}\"id\" : #{card.id},\n"
    exportText+= "#{TAB}\"keywords\" : #{JSON.stringify(getPackedTags(card.keywords))},\n"
    exportText+= "#{TAB}\"type\" : #{JSON.stringify(pickledCard.type)},\n"
    exportText+= "#{TAB}\"version\" : #{VERSION},\n"
    cardSchema = cardModel.getSchema(card.macro)
    if (cardSchema?)
      items = []
      for own name, type of cardSchema
        items.push([name, type])
        
      for j in [0..(items.length-1)]
        name = items[j][0]
        type = items[j][1]
        if j is items.length-1
          delimiter = ""
        else
          delimiter = ","
          
        if type is "string" or type is "int"
          if pickledCard[name]?
            exportText += "#{TAB}#{JSON.stringify(name)} : #{JSON.stringify(pickledCard[name])}#{delimiter}\n"
        else if type is "string[]"
          exportText += "#{TAB}#{JSON.stringify(name)} : [ \n"
          stringArray = pickledCard[name]
          console.log stringArray
          len = stringArray.length;
          if len > 1
            for i in [0..(len-2)]
              exportText += "#{TAB}#{TAB}#{JSON.stringify(stringArray[i])},\n"
          if len > 0
            exportText += "#{TAB}#{TAB}#{JSON.stringify(stringArray[len - 1])}\n"
          
          exportText += "#{TAB}]#{delimiter}\n"
    exportText += "}"
  
  @pickle = (card)->
    if card.macro is null
      card.macro = "custom"
    try 
      #pickledCard = translators[card.macro].pickle(card)
      translatedCard = cardModel.translate(card)
      return genExportText(translatedCard, card);
    catch e
      console.log e
      return "{error: error}"


  this      

window.app.service('cardPickler',['cardModel', cardPicklerService]);
      
    
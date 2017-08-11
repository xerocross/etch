(function(){
  
  var shuffle = function (array) {
      var currentIndex = array.length;
      var temporaryValue;
      var randomIndex;

      // While there remain elements to shuffle...
      while (0 !== currentIndex) {

        // Pick a remaining element...
        randomIndex = Math.floor(Math.random() * currentIndex);
        currentIndex -= 1;

        // And swap it with the current element.
        temporaryValue = array[currentIndex];
        array[currentIndex] = array[randomIndex];
        array[randomIndex] = temporaryValue;
      }

      return array;
    };
  
  var cardPresenter = function(fillBlankPresenter, foreignVocabPresenter) {
    this.present = function(card) {
      var displayData = card;
      var data = card.dynamicCard.data;
      switch(card.macro) {
        case "fill_blank":
          displayData = fillBlankPresenter.present(data);
          break;
        case "foreign_vocab":
          displayData = foreignVocabPresenter.present(data);
          break;
      }
      card['front_side'] = displayData.front_side;
      card['back_side'] = displayData.back_side;
      return card;
    }
  }
  app.service('cardPresenter',['fillBlankPresenter','foreignVocabPresenter', cardPresenter]);

  var fillBlankPresenter = function() {
    this.present = function (data) {
      var generator = data.generator;
      var front_side = data.generator;
      var pattern = /\?\?([\s\S]+?)\?\?([,.;:!])?/g
      var match;
      while ((match = pattern.exec(generator)) !== null)
      {
        var punctuation = "";
        var blankText = match[1];
        if (2 < match.length && typeof(match[2]) === 'string')
          punctuation = match[2];
        var replacementString = "<question-blank blank-text = 'BLANK" + punctuation + "' answer='" + blankText + punctuation + "'></question-blank>";
        front_side = front_side.replace(match[0],replacementString);
      }
      
      var secondPattern = /#{([\s\S]+?)}{([\s\S]+?)}([,.;:!])?/g
      pattern = secondPattern;
      while ((match = pattern.exec(generator)) !== null)
      {
        var punctuation = "";
        displayText = "";
        var blankText = match[1];
        var displayText = match[2];
        if (3 < match.length && typeof(match[3]) === 'string')
          punctuation = match[3];
        displayText += punctuation
        
        var replacementString = "<question-blank blank-text = '" + displayText + "' answer='" + blankText + punctuation + "'></question-blank>";
        front_side = front_side.replace(match[0],replacementString);
      }
      
      return {front_side: front_side, back_side:""};
    };
  };
  app.service('fillBlankPresenter',[fillBlankPresenter]);
  
  var multiChoiceRandomizer = function() {
    this.generateChoices = function(card) {
      choices = [];
      for (var i = 0; i < card.dynamicCard.data.answers.length; i++){
        choices.push({text: card.dynamicCard.data.answers[i],correct: true});
      }
      for (var i = 0; i < card.dynamicCard.data.distractors.length; i++){
        choices.push({text: card.dynamicCard.data.distractors[i],correct: false});
      }

      choices = shuffle(choices);
      card.choices = choices; 
    };
  }
  app.service('multiChoiceRandomizer',[multiChoiceRandomizer]);
  
  
  var cardService = function(crypt, $http, cardPresenter) {
    var service = this;
    
    var buildChoices = function(card) {
      choices = [];
      for (var i = 0; i < card.dynamicCard.data.answers.length; i++){
        choices.push({text: card.dynamicCard.data.answers[i],correct: true});
      }
      for (var i = 0; i < card.dynamicCard.data.distractors.length; i++){
        choices.push({text: card.dynamicCard.data.distractors[i],correct: false});
      }

      choices = shuffle(choices);
      card.choices = choices; 
    };
    
    
    this.parseCard = function(card) {
      card.front_side = crypt.decrypt(card.front_side);
      card.back_side = crypt.decrypt(card.back_side);
      card.data = crypt.decrypt(card.data);
      
      for (var i = 0; i < card.keywords.length; i++) {
        card.keywords[i].text = crypt.decrypt(card.keywords[i].text);
      }
      
      try {
        if (card.data !== null) {
          card.dynamicCard = JSON.parse(card.data);

          if(card.macro === "multi_choice")
          {
            buildChoices(card);
          }
          card = cardPresenter.present(card);
        }
        
        
      } catch(err) {
        console.log("there was some kind of error:" + err);
        card.dynamicCard = null;
      }

      return card;
    }
    
    
    
    this.getCards = function(query, container) {
      var urlString = "/flashcards.json?";
      if (typeof(query.page) === "number")
        urlString += "page=" + query.page + "&";
      return $http.get(urlString).then(function (obj) {
        var cards = obj.data;
        for (var i = 0; i < cards.length; i++) {
          var card = cards[i];
          card = service.parseCard(card);
          container.push(card);
        }
      });
    }
    
  };
  app.service('cardService',['crypt','$http','cardPresenter',cardService]);
  
  var foreignVocabPresenter = function() {
    this.present = function(data) {
      var front_side = "How do you say '" + data.originWord + "' in " + data.language + "?";
      var back_side = data.targetWord;
      return {front_side: front_side, back_side: back_side};
    };
  };
  app.service('foreignVocabPresenter',[foreignVocabPresenter]);
  
  var mathjaxService = function() {
    var that = this;
    var localMathJax = null;
    var loadMathJax = function(callback) {
      if (localMathJax === null) {
          console.log("loading mathjax");
          var success = function() {
            var localMathJax = MathJax;
            MathJax.Hub.Config({
                extensions: ["tex2jax.js"],
                jax: ["input/TeX", "output/HTML-CSS"],
                tex2jax: {
                    inlineMath: [ ["\\(","\\)"] ],
                    displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
                },
                "HTML-CSS": { availableFonts: ["TeX"] }
            });
            MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
        };
        
        $.getScript("https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.0/MathJax.js").done(function(){
          success();
          MathJax.Hub.Queue(["Typeset",MathJax.Hub,document]);
        });
      }
    };
    this.scan = function(string) {
      console.log("MATH SCAN WAS CALLED on argument:");
      console.log(string);
      if (string.match(/\\\([\s\S]+\\\)/g) || string.match(/\$\$[\s\S]+\$\$/g) || string.match(/\\\[[\s\S]+\\\]/g) ) {
        loadMathJax(function(){
          that.typeset(); 
        });
        
      }
    };

    this.typeset = function(){
      
      loadMathJax(function(){
        MathJax.Hub.Queue(["Typeset",MathJax.Hub]);
      });
    };
  };
  app.service('math',mathjaxService);
  app.service('mathService',mathjaxService);
  
  var statusPrinter = function() {
    var statusDiv = document.querySelector("#status");
    this.print = function(statusString) {
      var par = document.createElement("p");
      var textNode = document.createTextNode(statusString);
      par.appendChild(textNode);
      statusDiv.appendChild(par);
      var removeIt = function(){
        $(par).remove();
      }
      $(par).addClass("status");
      $(par).addClass("status-top");
      setTimeout(removeIt, 3000);
    };
  };
  app.service('statusPrinter',[statusPrinter]);
  
  var exportService = function(cardPickler) {

    this.getExportText = function(cards) {
    var exportText = "[";
        
        for (var i = 0, max = cards.length - 1; i < max; i++)
        {
          exportText += cardPickler.pickle(cards[i]) + ",\n";
        }
        if (cards.length > 0)
          exportText += cardPickler.pickle(cards[cards.length - 1]) + "\n";
        exportText += "]";

        return exportText;
    };


  };
  app.service('exportService',['cardPickler', exportService]);

  
})()
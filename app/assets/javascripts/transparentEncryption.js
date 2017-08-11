var ready = function(){
    var password = localStorage.password;
    var encrypt = function(plaintext) {
        var ciphertext = base64_encode(AESEncryptCtr(plaintext, password, 256));
        return "!" + ciphertext + "!";
    };
    var decrypt = function(input) {
        var re = /!([a-zA-Z0-9+/=]*)!/g;
        var match = re.exec(input);
        if (match === null)
            return input;
        var ciphertext = match[1];
        var plaintext = AESDecryptCtr(base64_decode(ciphertext), password, 256);
        return plaintext;
    };
    
    
    var divs = $("div[cal-directive ~= 'cipher-transparent']").get();
    divs.forEach(function(div){
        var elements = $(div).find("[cal-encrypt = 'decrypt']").get();
        elements.forEach(function(element){
            var ciphertext = $(element).html();
            $(element).html(decrypt(ciphertext));
        });
    });
    
    
    var forms = $("form[cal-directive = 'cipher-transparent']").get();
    forms.forEach(function(form){
        var encryptedChilren = $(form).find("[cal-encrypt = 'encrypt']").get();
        encryptedChilren.forEach(function(element){
            $(element).val(decrypt($(element).val()));
        });
        $(form).submit(function(e){
            encryptedChilren.forEach(function(input){
                $(input).val(encrypt($(input).val()));
            });
        });
    });
};
$(document).on('turbolinks:load', ready);
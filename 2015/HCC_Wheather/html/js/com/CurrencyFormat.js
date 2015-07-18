var CurrencyFormat = (function() {
    
    return {
        make: function($str) { 
            var num = $str.trim();

            while ((/(-?[0-9]+)([0-9]{3})/).test(num)) {
                num = num.replace((/(-?[0-9]+)([0-9]{3})/), "$1,$2");
            }

            return num;
        }
    }
    
})(CurrencyFormat);


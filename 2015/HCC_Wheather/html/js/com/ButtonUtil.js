var ButtonUtil = (function() {
    
    return {
        makeButton: function($target, $fn) {
            $($target).css({"cursor":"pointer"});
            $($target).bind("mouseenter", $fn);
            $($target).bind("mouseleave", $fn);
            $($target).bind("click", $fn);
        },
        removeButton: function($target, $fn) { 
            $($target).css({"cursor":"auto"});
            $($target).unbind("mouseenter", $fn);
            $($target).unbind("mouseleave", $fn);
            $($target).unbind("click", $fn);
        }
    }
    
})(ButtonUtil);


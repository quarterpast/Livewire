if (typeof window == 'undefined' || window === null) {
  require('prelude-ls').installPrelude(global);
} else {
  prelude.installPrelude(window);
}
(function(){
  var Matcher, FunctionMatcher, out$ = typeof exports != 'undefined' && exports || this;
  Matcher = require('../matcher').Matcher;
  out$.FunctionMatcher = FunctionMatcher = (function(superclass){
    var prototype = extend$((import$(FunctionMatcher, superclass).displayName = 'FunctionMatcher', FunctionMatcher), superclass).prototype, constructor = FunctionMatcher;
    function FunctionMatcher(path){
      var this$ = this instanceof ctor$ ? this : new ctor$;
      this$.path = path;
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    FunctionMatcher.supports = (function(it){
      return it instanceof Function;
    });
    prototype.match = function(req){
      return false !== this.path(req);
    };
    prototype.extract = function(it){
      return this.path(it);
    };
    return FunctionMatcher;
  }(Matcher));
  function extend$(sub, sup){
    function fun(){} fun.prototype = (sub.superclass = sup).prototype;
    (sub.prototype = new fun).constructor = sub;
    if (typeof sup.extended == 'function') sup.extended(sub);
    return sub;
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);

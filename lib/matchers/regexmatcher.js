(function(){
  var Matcher, RegexMatcher, out$ = typeof exports != 'undefined' && exports || this;
  Matcher = require('../matcher').Matcher;
  out$.RegexMatcher = RegexMatcher = (function(superclass){
    var prototype = extend$((import$(RegexMatcher, superclass).displayName = 'RegexMatcher', RegexMatcher), superclass).prototype, constructor = RegexMatcher;
    function RegexMatcher(path){
      var ref$, this$ = this instanceof ctor$ ? this : new ctor$;
      this$.path = path;
      this$.params = (ref$ = path.params) != null
        ? ref$
        : [];
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    RegexMatcher.supports = (function(it){
      return it instanceof RegExp;
    });
    prototype.match = function(req){
      return this.path.test(req.pathname);
    };
    prototype.extract = function(req){
      var vals, ref$;
      vals = tail((ref$ = this.reg.exec(req.pathname)) != null
        ? ref$
        : []);
      if (empty(this.params)) {
        return vals;
      } else {
        return listToObj(zip(this.params, vals));
      }
    };
    return RegexMatcher;
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

(function(){
  var Router, Matcher, MatcherRouter, out$ = typeof exports != 'undefined' && exports || this;
  Router = require('../router').Router;
  Matcher = require('../matcher').Matcher;
  out$.MatcherRouter = MatcherRouter = (function(superclass){
    var prototype = extend$((import$(MatcherRouter, superclass).displayName = 'MatcherRouter', MatcherRouter), superclass).prototype, constructor = MatcherRouter;
    MatcherRouter.supports = function(spec){
      return spec instanceof Matcher || any(function(it){
        return it.supports(spec);
      }, Matcher.subclasses);
    };
    prototype.match = function(it){
      return superclass.prototype.match.apply(this, arguments) && this.matcher.match(it);
    };
    prototype.extract = function(it){
      return this.matcher.extract(it);
    };
    prototype.handlers = function(){
      return [].concat(this.handler);
    };
    function MatcherRouter(method, matcher, handler){
      var this$ = this instanceof ctor$ ? this : new ctor$;
      this$.matcher = matcher;
      this$.handler = handler;
      MatcherRouter.superclass.call(this$, method);
      if (!(matcher instanceof Matcher)) {
        this$.matcher = Matcher.create(matcher);
      }
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    return MatcherRouter;
  }(Router));
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

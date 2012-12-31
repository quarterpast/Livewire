(function(){
  var Router, Matcher, delegate, instanceTracker, MatcherRouter, out$ = typeof exports != 'undefined' && exports || this;
  Router = require('../router').Router;
  Matcher = require('../matcher').Matcher;
  delegate = require('../meta').delegate;
  instanceTracker = require('../meta').instanceTracker;
  out$.MatcherRouter = MatcherRouter = (function(superclass){
    var constructor$$, prototype = extend$((import$(MatcherRouter, superclass).displayName = 'MatcherRouter', MatcherRouter), superclass).prototype, constructor = MatcherRouter;
    importAll$(prototype, arguments[1]);
    function MatcherRouter(){
      return constructor$$.apply(this, arguments);
    }
    MatcherRouter.supports = function(spec){
      return spec instanceof Matcher || any(function(it){
        return it.supports(spec);
      }, Matcher.subclasses);
    };
    prototype.handlers = function(){
      return [this.handler];
    };
    constructor$$ = instanceTracker(function(matcher, handler){
      MatcherRouter.matcher = matcher;
      MatcherRouter.handler = handler;
      if (!(matcher instanceof Matcher)) {
        return MatcherRouter.matcher = Matcher.create(matcher);
      }
    });
    return MatcherRouter;
  }(Router, delegate(['match', 'extract'], 'matcher')));
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
  function importAll$(obj, src){
    for (var key in src) obj[key] = src[key];
    return obj;
  }
}).call(this);

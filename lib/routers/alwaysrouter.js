(function(){
  var Router, AlwaysRouter, out$ = typeof exports != 'undefined' && exports || this;
  Router = require('../router').Router;
  out$.AlwaysRouter = AlwaysRouter = (function(superclass){
    var prototype = extend$((import$(AlwaysRouter, superclass).displayName = 'AlwaysRouter', AlwaysRouter), superclass).prototype, constructor = AlwaysRouter;
    AlwaysRouter.supports = (function(it){
      return it === true;
    });
    prototype.handlers = function(){
      return [].concat(this.handler);
    };
    prototype.match = function(){
      return true;
    };
    prototype.extract = function(){
      return {};
    };
    function AlwaysRouter(method, arg$, handler){
      var this$ = this instanceof ctor$ ? this : new ctor$;
      this$.handler = handler;
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    return AlwaysRouter;
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

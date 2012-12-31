(function(){
  var requireAll, Router, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice;
  requireAll = require('./meta').requireAll;
  requireAll("./routers");
  out$.Router = Router = (function(){
    Router.displayName = 'Router';
    var prototype = Router.prototype, constructor = Router;
    Router.subclasses = [];
    Router.extended = bind$(Router.subclasses, 'push');
    Router.create = function(method){
      var spec, that;
      spec = slice$.call(arguments, 1);
      if (that = find(function(it){
        return typeof it.supports === 'function' ? it.supports.apply(null, spec) : void 8;
      }, this.subclasses)) {
        return that.apply(null, [method].concat(slice$.call(spec)));
      } else {
        throw new TypeError("No routers can handle " + spec + ".");
      }
    };
    Router.route = function(req){
      return concatMap(function(it){
        return it.find(req);
      }, constructor.subclasses);
    };
    Router.error = curry$(function(res, err){
      var ref$;
      if (err != null) {
        res.statusCode = 500;
        res.end();
        return console.error((ref$ = err.stack) != null
          ? ref$
          : err.toString());
      }
    });
    Router.find = function(req){
      return concatMap(function(it){
        return it.handlers();
      })(
      filter(function(it){
        return it.match(req);
      }, this.instances));
    };
    prototype.match = function(){
      throw new TypeError(this.constructor.displayName + " does not implement match");
    };
    prototype.handlers = function(){
      throw new TypeError(this.constructor.displayName + " does not implement handlers");
    };
    prototype.extract = function(){
      throw new TypeError(this.constructor.displayName + " does not implement extract");
    };
    function Router(){
      var this$ = this instanceof ctor$ ? this : new ctor$;
      throw new TypeError(this$.constructor.displayName + " is abstract and can't be instantiated.");
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    return Router;
  }());
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
  function curry$(f, args){
    return f.length > 1 ? function(){
      var params = args ? args.concat() : [];
      return params.push.apply(params, arguments) < f.length && arguments.length ?
        curry$.call(this, f, params) : f.apply(this, params);
    } : f;
  }
}).call(this);

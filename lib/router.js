(function(){
  var requireFolder, Router, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice;
  requireFolder = require('require-folder');
  out$.Router = Router = (function(){
    Router.displayName = 'Router';
    var prototype = Router.prototype, constructor = Router;
    Router.subclasses = [];
    Router.extended = bind$(Router.subclasses, 'push');
    Router.routers = [];
    Router.create = function(method){
      var spec, that;
      spec = slice$.call(arguments, 1);
      if (that = find(function(it){
        return typeof it.supports === 'function' ? it.supports.apply(null, spec) : void 8;
      }, this.subclasses)) {
        return this.routers.push(that.apply(null, [method].concat(slice$.call(spec))));
      } else {
        throw new TypeError("No routers can handle " + spec + ".");
      }
    };
    Router.route = function(req){
      return filter(function(it){
        return it.match(req);
      }, constructor.routers);
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
    prototype.match = function(it){
      var ref$;
      return (ref$ = this.method) == 'ANY' || ref$ == it.method;
    };
    prototype.handlers = function(){
      throw new TypeError(this.constructor.displayName + " does not implement handlers");
    };
    prototype.extract = function(){
      throw new TypeError(this.constructor.displayName + " does not implement extract");
    };
    function Router(method){
      var this$ = this instanceof ctor$ ? this : new ctor$;
      this$.method = method;
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    return Router;
  }());
  requireFolder("./routers");
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
  function curry$(f, bound){
    var context,
    _curry = function(args) {
      return f.length > 1 ? function(){
        var params = args ? args.concat() : [];
        context = bound ? context || this : this;
        return params.push.apply(params, arguments) <
            f.length && arguments.length ?
          _curry.call(context, params) : f.apply(context, params);
      } : f;
    };
    return _curry();
  }
}).call(this);

(function(){
  var sync, url, Router, Matcher, Request, Response, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice;
  sync = require('sync');
  url = require('url');
  Router = require('./router').Router;
  Matcher = require('./matcher').Matcher;
  out$.Router = Router;
  out$.Matcher = Matcher;
  String.prototype.pipe = function(it){
    return it.end(this.constructor(this));
  };
  Buffer.prototype.pipe = function(it){
    return it.end(this);
  };
  out$.Request = Request = (function(){
    Request.displayName = 'Request';
    var prototype = Request.prototype, constructor = Request;
    prototype.params = {};
    function Request(req){
      var this$ = this instanceof ctor$ ? this : new ctor$;
      import$(this$, req);
      import$(this$, url.parse(req.url, true));
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    return Request;
  }());
  out$.Response = Response = (function(){
    Response.displayName = 'Response';
    var prototype = Response.prototype, constructor = Response;
    function Response(res){
      var this$ = this instanceof ctor$ ? this : new ctor$;
      import$(this$, res);
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    return Response;
  }());
  out$.app = app;
  function app(req, res){
    var this$ = this;
    return sync(function(){
      var augReq, fns, res$, i$, ref$, len$, route, e;
      try {
        augReq = Request(req);
        res$ = [];
        for (i$ = 0, len$ = (ref$ = Router.route(req)).length; i$ < len$; ++i$) {
          route = ref$[i$];
          res$.push((fn$.call(this$, augReq, res, route)));
        }
        fns = res$;
        return function(it){
          return it.on('error', Router.error(res));
        }(
        function(it){
          return it.pipe(augRes);
        }(
        fold(curry$(function(x$, y$){
          return x$(y$);
        }), "404 " + req.pathname)(
        fns)));
      } catch (e$) {
        e = e$;
        return Router.error(res, e);
      }
      function fn$(augReq, res, route){
        import$(augReq.params, route.extract(augReq));
        return function(it){
          return route.func.sync(augReq, Response(res), it);
        };
      }
    });
  }
  each(function(method){
    var this$ = this;
    return exports[method] = function(){
      var spec;
      spec = slice$.call(arguments);
      return Router.create.apply(Router, [method].concat(slice$.call(spec)));
    };
  })(
  ['ANY', 'GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'TRACE', 'CONNECT', 'HEAD']);
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
  function curry$(f, args){
    return f.length > 1 ? function(){
      var params = args ? args.concat() : [];
      return params.push.apply(params, arguments) < f.length && arguments.length ?
        curry$.call(this, f, params) : f.apply(this, params);
    } : f;
  }
}).call(this);

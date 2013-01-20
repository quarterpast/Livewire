(function(){
  var sync, url, Router, Matcher, Request, Response, async, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice;
  sync = require('sync');
  url = require('url');
  Router = require('./router').Router;
  Matcher = require('./matcher').Matcher;
  out$.Router = Router;
  out$.Matcher = Matcher;
  String.prototype.pipe = function(it){
    it.end(this.constructor(this));
    return it;
  };
  Buffer.prototype.pipe = function(it){
    it.end(this);
    return it;
  };
  out$.Request = Request = (function(){
    Request.displayName = 'Request';
    var prototype = Request.prototype, constructor = Request;
    prototype.params = {};
    function Request(req){
      var k, v, this$ = this instanceof ctor$ ? this : new ctor$;
      for (k in req) {
        v = req[k];
        this$[k] = v instanceof Function ? v.bind(req) : v;
      }
      import$(this$, url.parse(req.url, true));
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    return Request;
  }());
  out$.Response = Response = (function(){
    Response.displayName = 'Response';
    var prototype = Response.prototype, constructor = Response;
    function Response(res){
      var k, v, this$ = this instanceof ctor$ ? this : new ctor$;
      for (k in res) {
        v = res[k];
        this$[k] = v instanceof Function ? v.bind(res) : v;
      }
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    return Response;
  }());
  exports.use = function(it){
    return Router.create('ANY', true, it);
  };
  exports.use(function(res){
    var end$, this$ = this;
    this.statusCode = 404;
    end$ = res.end;
    res.end = function(){
      console.log(res.statusCode + " " + this$.pathname);
      return end$.apply(res, arguments);
    };
    return "404 " + this.pathname;
  });
  out$.app = app;
  function app(req, res){
    var augs, this$ = this;
    augs = {
      req: Request(req),
      res: Response(res)
    };
    return sync(function fiber(){
      return function(it){
        return it.on('error', Router.error(augs.res));
      }(
      function(it){
        return it.pipe(augs.res);
      }(
      fold(curry$(function(x$, y$){
        return y$(x$);
      }), "")(
      concatMap(compose$([
        map(curry$(function(func, last){
          augs.res.statusCode = 200;
          return func[/.async()$/.exec(func.toString()) ? 'sync' : 'call'](augs.req, augs.res, last);
        })), function(it){
          return it.handlers;
        }
      ]))(
      each(compose$([
        (function(it){
          return import$(augs.req.params, it);
        }), function(it){
          return it.extract(augs.req);
        }
      ]))(
      Router.route(augs.req))))));
    }, Router.error(augs.res));
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
  out$.async = async = function(it){
    return it.async();
  };
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
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
  function compose$(fs){
    return function(){
      var i, args = arguments;
      for (i = fs.length; i > 0; --i) { args = [fs[i-1].apply(this, args)]; }
      return args[0];
    };
  }
}).call(this);

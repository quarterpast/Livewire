(function(){
  var sync, url, PathMatcher, StringMatcher, RegexpMatcher, FunctionMatcher, AlwaysMatcher, Request, Response, Route, method, slice$ = [].slice, toString$ = {}.toString, this$ = this;
  sync = require('sync');
  url = require('url');
  exports.PathMatcher = PathMatcher = (function(){
    PathMatcher.displayName = 'PathMatcher';
    var prototype = PathMatcher.prototype, constructor = PathMatcher;
    function PathMatcher(){}
    PathMatcher.extended = bind$(PathMatcher.subclasses || (PathMatcher.subclasses = []), 'push');
    PathMatcher.create = curry$(function(pathspec){
      var that;
      if (that = find(function(it){
        return it.handles(pathspec);
      }, this.subclasses)) {
        return new that(pathspec);
      } else {
        throw TypeError("No routers can handle " + pathspec);
      }
    });
    prototype.match = function(){
      throw TypeError(this.constructor.displayName + " does not implement match");
    };
    prototype.extend = function(){
      throw TypeError(this.constructor.displayName + " does not implement extend");
    };
    return PathMatcher;
  }());
  StringMatcher = (function(superclass){
    var prototype = extend$((import$(StringMatcher, superclass).displayName = 'StringMatcher', StringMatcher), superclass).prototype, constructor = StringMatcher;
    StringMatcher.handles = compose$([
      (function(it){
        return it === 'string';
      }), (function(it){
        return typeof it;
      })
    ]);
    function StringMatcher(path){
      var this$ = this;
      this.params = [];
      this.reg = partialize$(RegExp, [void 8, 'i'], [0])(
      function(it){
        return ("^" + it) + ('/' === last(path) ? '' : '$');
      }(
      path.replace(/:([a-z$_][a-z0-9$_]*)/i, function(m, param){
        this$.params.push(param);
        return '([^\\/]+)';
      })));
    }
    prototype.match = function(req){
      return this.reg.test(req.pathname);
    };
    prototype.extract = function(req){
      var ref$;
      return listToObj(
      zip(this.params)(
      tail(
      (ref$ = this.reg.exec(req.pathname)) != null
        ? ref$
        : [])));
    };
    return StringMatcher;
  }(PathMatcher));
  RegexpMatcher = (function(superclass){
    var prototype = extend$((import$(RegexpMatcher, superclass).displayName = 'RegexpMatcher', RegexpMatcher), superclass).prototype, constructor = RegexpMatcher;
    RegexpMatcher.handles = (function(it){
      return it instanceof RegExp;
    });
    function RegexpMatcher(reg){
      this.reg = reg;
    }
    prototype.match = function(req){
      return this.reg.test(req.pathname);
    };
    prototype.extract = function(req){
      var ref$;
      return tail((ref$ = this.reg.exec(req.pathname)) != null
        ? ref$
        : []);
    };
    return RegexpMatcher;
  }(PathMatcher));
  FunctionMatcher = (function(superclass){
    var prototype = extend$((import$(FunctionMatcher, superclass).displayName = 'FunctionMatcher', FunctionMatcher), superclass).prototype, constructor = FunctionMatcher;
    FunctionMatcher.handles = (function(it){
      return it instanceof Function;
    });
    function FunctionMatcher(func){
      this.func = func;
    }
    prototype.match = function(req){
      return false !== (this.result = this.func(req.pathname));
    };
    prototype.extract = function(req){
      return this.result;
    };
    return FunctionMatcher;
  }(PathMatcher));
  AlwaysMatcher = (function(superclass){
    var prototype = extend$((import$(AlwaysMatcher, superclass).displayName = 'AlwaysMatcher', AlwaysMatcher), superclass).prototype, constructor = AlwaysMatcher;
    AlwaysMatcher.handles = (function(it){
      return it === true;
    });
    prototype.match = function(){
      return true;
    };
    prototype.extract = function(){
      return {};
    };
    function AlwaysMatcher(){
      AlwaysMatcher.superclass.apply(this, arguments);
    }
    return AlwaysMatcher;
  }(PathMatcher));
  exports.Request = Request = (function(){
    Request.displayName = 'Request';
    var prototype = Request.prototype, constructor = Request;
    prototype.params = {};
    function Request(req){
      var this$ = this instanceof ctor$ ? this : new ctor$;
      console.log(req);
      import$(this$, req);
      import$(this$, url.parse(req.url, true));
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    return Request;
  }());
  exports.Response = Response = (function(){
    Response.displayName = 'Response';
    var prototype = Response.prototype, constructor = Response;
    function Response(res){
      var this$ = this instanceof ctor$ ? this : new ctor$;
      import$(this$, res);
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    return Response;
  }());
  exports.Route = Route = (function(){
    Route.displayName = 'Route';
    var prototype = Route.prototype, constructor = Route;
    Route.routes = [];
    Route.error = function(err){
      var ref$;
      if (err != null) {
        res.statusCode = 500;
        res.end();
        return console.error((ref$ = err.stack) != null
          ? ref$
          : err.toString());
      }
    };
    function Route(method, pathspec, func){
      var i$, len$, fn, this$ = this instanceof ctor$ ? this : new ctor$;
      this$.method = method;
      this$.func = func;
      if (toString$.call(func).slice(8, -1) === 'Array') {
        for (i$ = 0, len$ = func.length; i$ < len$; ++i$) {
          fn = func[i$];
          Route(method, pathspec, fn);
        }
      } else {
        this$.matcher = PathMatcher.create(pathspec);
        constructor.routes.push(this$);
      }
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    return Route;
  }());
  for (method in {
    'ANY': 'ANY',
    'GET': 'GET',
    'POST': 'POST',
    'PUT': 'PUT',
    'DELETE': 'DELETE',
    'OPTIONS': 'OPTIONS',
    'TRACE': 'TRACE',
    'CONNECT': 'CONNECT',
    'HEAD': 'HEAD'
  }) {
    exports[method] = fn$;
  }
  exports.use = function(it){
    return Route('ANY', true, it);
  };
  exports.use(function(){
    this.statusCode = 404;
    return "404 " + this.pathname;
  });
  exports.app = function(req, res){
    var this$ = this;
    return sync(function(){
      var req, res, route;
      console.log(req.url);
      req = new Request(req);
      res = new Response(res);
      return fold1(curry$(function(x$, y$){
        return y$(x$);
      }))((function(){
        var i$, ref$, len$, results$ = [];
        for (i$ = 0, len$ = (ref$ = Route.routes).length; i$ < len$; ++i$) {
          route = ref$[i$];
          if (route.match(req)) {
            import$(req.params, route.extract(req));
            results$.push(fn$);
          }
        }
        return results$;
        function fn$(it){
          return this.func.sync(req, res, it);
        }
      }()));
    });
  };
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
  function compose$(fs){
    return function(){
      var i, args = arguments;
      for (i = fs.length; i > 0; --i) { args = [fs[i-1].apply(this, args)]; }
      return args[0];
    };
  }
  function partialize$(f, args, where){
    return function(){
      var params = slice$.call(arguments), i,
          len = params.length, wlen = where.length,
          ta = args ? args.concat() : [], tw = where ? where.concat() : [];
      for(i = 0; i < len; ++i) { ta[tw[0]] = params[i]; tw.shift(); }
      return len < wlen && len ? partialize$(f, ta, tw) : f.apply(this, ta);
    };
  }
  function fn$(path, funcs){
    return Route(method, path, funcs);
  }
}).call(this);

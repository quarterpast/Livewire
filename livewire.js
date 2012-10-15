(function(){
  var Router, toString$ = {}.toString, slice$ = [].slice;
  String.prototype.pipe = Buffer.prototype.pipe = function(it){
    return it.end(this.constructor(this));
  };
  module.exports = new (Router = (function(){
    Router.displayName = 'Router';
    var prototype = Router.prototype, constructor = Router;
    prototype.respond = curry$(function(method, path, funcs){
      var params, reg;
      reg = (function(){
        switch (toString$.call(path).slice(8, -1)) {
        case 'String':
          params = unfold(function(ident){
            var that;
            if (that = ident.exec(path)) {
              path = path.replace(ident, '([^\\/]+)');
              return [that[1], ident];
            }
          })(
          /:([a-z$_][a-z0-9$_]*)/i);
          return RegExp("^" + path + "$", 'i');
        case 'RegExp':
          return path;
        case 'Function':
          return {
            test: path,
            exec: path
          };
        default:
          throw new TypeError("Invalid path " + path);
        }
      }());
      return each(bind$(this.routes, 'push'))(
      concatMap(compose$([
        (function(it){
          return import$(it, (function(orig){
            return {
              match: function(it){
                return (method == 'ANY' || method == it.method) && (orig != null
                  ? orig
                  : compose$([
                    bind$(reg, 'test'), function(it){
                      return it.pathname;
                    }
                  ]))(it);
              },
              extract: function(it){
                var ref$, values, that;
                values = (ref$ = reg.exec(it.pathname)) != null
                  ? ref$
                  : [];
                import$(it.params || (it.params = {}), (that = params) != null ? listToObj(
                zip(that)(
                tail(values))) : values);
                return this;
              }
            };
          }.call(this, it.match)));
        }), function(it){
          return it.async();
        }
      ]))(
      [].concat(funcs)));
    });
    import$(prototype, map(prototype.respond, {
      'ANY': 'ANY',
      'GET': 'GET',
      'POST': 'POST',
      'PUT': 'PUT',
      'DELETE': 'DELETE',
      'OPTIONS': 'OPTIONS',
      'TRACE': 'TRACE',
      'CONNECT': 'CONNECT',
      'HEAD': 'HEAD'
    }));
    function Router(routes){
      var server, this$ = this instanceof ctor$ ? this : new ctor$;
      this$.routes = routes != null
        ? routes
        : [];
      server = require('http').createServer(function(req, res){
        return require('sync')(function(){
          var ref$, end$, start, r, e, that;
          try {
            ref$ = [
              res.end, Date.now(), function(){
                console.log(res.statusCode + " " + req.url + ": " + (Date.now() - start) + "ms");
                return end$.apply(this, arguments);
              }
            ], end$ = ref$[0], start = ref$[1], res.end = ref$[2];
            import$(req, require('url').parse(req.url, true));
            return function(it){
              return it.pipe(res);
            }(
            fold(curry$(function(x$, y$){
              return y$(x$);
            }), "404 " + req.url)(
            (function(){
              var i$, ref$, len$, results$ = [];
              for (i$ = 0, len$ = (ref$ = this.routes).length; i$ < len$; ++i$) {
                r = ref$[i$];
                if (r.match(req)) {
                  results$.push(partialize$(r.extract(req).sync, [req, res, void 8], [2]));
                }
              }
              return results$;
            }.call(this$))));
          } catch (e$) {
            e = e$;
            return ((that = this$.error) != null
              ? that
              : bind$(res, 'end'))(e.stack);
          }
        });
      });
      return importAll$(server, this$);
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    return Router;
  }()));
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
  function compose$(fs){
    return function(){
      var i, args = arguments;
      for (i = fs.length; i > 0; --i) { args = [fs[i-1].apply(this, args)]; }
      return args[0];
    };
  }
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
  function partialize$(f, args, where){
    return function(){
      var params = slice$.call(arguments), i,
          len = params.length, wlen = where.length,
          ta = args ? args.concat() : [], tw = where ? where.concat() : [];
      for(i = 0; i < len; ++i) { ta[tw[0]] = params[i]; tw.shift(); }
      return len < wlen && len ? partialize$(f, ta, tw) : f.apply(this, ta);
    };
  }
  function importAll$(obj, src){
    for (var key in src) obj[key] = src[key];
    return obj;
  }
}).call(this);

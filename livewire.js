(function(){
  var sync, ref$, map, filter, fold, each, unfold, zip, listToObj, Router, slice$ = [].slice;
  sync = require('sync');
  ref$ = require('prelude-ls'), map = ref$.map, filter = ref$.filter, fold = ref$.fold, each = ref$.each, unfold = ref$.unfold, zip = ref$.zip, listToObj = ref$.listToObj;
  module.exports = new (Router = (function(){
    Router.displayName = 'Router';
    var prototype = Router.prototype, constructor = Router;
    prototype.routes = [];
    prototype.respond = curry$(function(method, path, funcs){
      var params, reg;
      params = unfold(function(reg){
        var that;
        if (that = reg.exec(path)) {
          path = path.replace(reg, '([^\\/]+)');
          return [that[1], reg];
        }
      })(
      /:([a-z$_][a-z0-9$_]*)/i);
      reg = RegExp("^" + path + "$", 'i');
      return map(compose$([
        bind$(this.routes, 'push'), (function(it){
          var ref$;
          return import$(it, {
            match: (ref$ = it.match) != null
              ? ref$
              : function(req){
                return (method == 'ANY' || method == req.method) && reg.test(req.url);
              },
            extract: (ref$ = it.extract) != null
              ? ref$
              : function(req){
                var ref$, m, values;
                ref$ = (ref$ = reg.exec(req.url)) != null
                  ? ref$
                  : [], m = ref$[0], values = slice$.call(ref$, 1);
                return listToObj(
                zip(params, values));
              }
          });
        }), function(it){
          return it.async();
        }
      ]))(
      [].concat(funcs));
    });
    prototype.use = function(it){
      return this.routes.push(it);
    };
    import$(prototype, map(prototype.respond, {
      'ANY': 'ANY',
      'GET': 'GET',
      'POST': 'POST',
      'PUT': 'PUT',
      'DELETE': 'DELETE',
      'OPTIONS': 'OPTIONS',
      'TRACE': 'TRACE',
      'PATCH': 'PATCH',
      'CONNECT': 'CONNECT',
      'HEAD': 'HEAD'
    }));
    prototype['*'] = prototype.any;
    function Router(){
      var server, this$ = this instanceof ctor$ ? this : new ctor$;
      server = require('http').createServer(function(req, res){
        return sync(function(){
          var out, e;
          try {
            console.time(req.method + " " + req.url);
            out = fold(function(out, route){
              return route.sync(req, res, out);
            }, "404 " + req.url)(
            each(compose$([
              (function(it){
                return import$(req.params || (req.params = {}), it);
              }), function(it){
                return it.extract(req);
              }
            ]))(
            filter(function(it){
              return it.match(req);
            })(
            this$.routes)));
            res.writeHead(res.statusCode, res.headers || (res.headers = {}));
            (out.readable
              ? function(it){
                return it.pipe(res);
              }
              : bind$(res, 'end'))(
            out);
            return console.timeEnd(req.method + " " + req.url);
          } catch (e$) {
            e = e$;
            return res.end(e.stack);
          }
        });
      });
      return importAll$(server, this$);
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    return Router;
  }()));
  function compose$(fs){
    return function(){
      var i, args = arguments;
      for (i = fs.length; i > 0; --i) { args = [fs[i-1].apply(this, args)]; }
      return args[0];
    };
  }
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
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
  function importAll$(obj, src){
    for (var key in src) obj[key] = src[key];
    return obj;
  }
}).call(this);

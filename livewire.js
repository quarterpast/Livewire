(function(){
  var sync, ref$, toString$ = {}.toString, slice$ = [].slice;
  sync = require('sync');
  String.prototype.pipe = Buffer.prototype.pipe = function(it){
    return it.end(this.constructor(this));
  };
  module.exports = (function(me, routes){
    var server;
    me.respond = curry$(function(method, path, funcs){
      var origPath, params, reg;
      reg = (function(){
        switch (toString$.call(origPath = path).slice(8, -1)) {
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
      return each(bind$(routes, 'push'))(
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
                  ]))((it.route = origPath, it));
              },
              carp: function(it){
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
    me.use = curry$(function(fn){
      return routes.push((fn.match = function(){
        return true;
      }, fn.carp = function(){
        return this;
      }, fn));
    });
    import$(me, map(me.respond, {
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
    server = require('http').createServer(function(req, res, start, end$){
      start == null && (start = Date.now());
      end$ == null && (end$ = res.end);
      return sync(function(){
        var r, e;
        try {
          res.end = function(){
            console.log(res.statusCode + " " + req.url + ": " + (Date.now() - start) + "ms");
            return end$.apply(this, arguments);
          };
          import$(req, require('url').parse(req.url, true));
          return fold1(curry$(function(x$, y$){
            return y$(x$);
          }), (function(){
            var i$, ref$, len$, results$ = [];
            for (i$ = 0, len$ = (ref$ = routes).length; i$ < len$; ++i$) {
              r = ref$[i$];
              if (r.match(req)) {
                results$.push(partialize$(r.carp(req).sync, [req, res, void 8], [2]));
              }
            }
            return results$;
          }())).pipe(res);
        } catch (e$) {
          e = e$;
          return res.end(e.stack);
        }
      });
    });
    return importAll$(server, me);
  }.call(this, {}, [(ref$ = function(it){
    it.statusCode = 404;
    return "404 " + this.pathname;
  }, ref$.match = function(){
    return true;
  }, ref$.carp = function(){
    return this;
  }, ref$)]));
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

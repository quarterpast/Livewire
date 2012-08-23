(function(){
  var sync, routes, respond, slice$ = [].slice;
  sync = require('sync');
  import$(global, require('prelude-ls'));
  routes = [];
  respond = curry$(function(method, path, func){
    var params, reg;
    params = unfold(function(reg){
      var that;
      if (that = reg.exec(path)) {
        path = path.replace(reg, '([^\\/]+)');
        return [that[0], reg];
      }
    })(
    /:([a-z$_][a-z0-9$_]*)/i);
    reg = RegExp("^" + path + "$", 'i');
    func = func.async();
    func.match = curry$(function(req){
      var ref$, m, values;
      if (method === req.method) {
        ref$ = (ref$ = reg.exec(req.url)) != null
          ? ref$
          : [], m = ref$[0], values = slice$.call(ref$, 1);
        if (m != null) {
          return listToObj(
          zip(params, values));
        }
      }
    });
    return routes.push(func);
  });
  module.exports = require('http').createServer(function(req, res){
    return sync(function(){
      var e;
      try {
        console.time(req.method + " " + req.url);
        bind$(res, 'end')(
        fold(function(out, route){
          return route.sync(req, res, out);
        }, "404 " + req.url)(
        each(compose$([
          (function(it){
            return import$(req.params || (req.params = {}), it);
          }), function(it){
            return it.match(req);
          }
        ]))(
        filter(function(it){
          return it.match(req);
        })(
        routes))));
        return console.timeEnd(req.method + " " + req.url);
      } catch (e$) {
        e = e$;
        return console.warn(e.stack);
      }
    });
  });
  map(function(it){
    return module.exports[it] = respond(it.toUpperCase());
  })(
  ['any', 'get', 'post', 'put', 'delete', 'options', 'trace', 'patch', 'connect', 'head']);
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
}).call(this);

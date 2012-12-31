(function(){
  var fs, path, callsite, instanceTracker, requireAll, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice;
  fs = require('fs');
  path = require('path');
  callsite = require('callsite');
  out$.delegate = delegate;
  function delegate(methods, unto){
    return fold1(curry$(function(x$, y$){
      return import$(x$, y$);
    }))(
    map(function(method){
      var ref$;
      return ref$ = {}, ref$[method] = function(){
        return this[unto][method].apply(this, arguments);
      }, ref$;
    })(
    methods));
  }
  out$.instanceTracker = instanceTracker = function(constr){
    var this$ = this;
    return function(){
      var x$;
      x$ = constr.apply(this$, arguments);
      (this$.instances || (this$.instances = [])).push(x$);
      x$;
      return x$;
    };
  };
  out$.requireAll = requireAll = function(dir){
    dir = partialize$(path.resolve, [void 8, dir], [0])(
    path.dirname(
    __stack[1].getFileName()));
    return fold(curry$(function(x$, y$){
      return import$(x$, y$);
    }), {})(
    map(compose$([require, partialize$(path.join, [dir, void 8], [1])]))(
    filter(compose$([
      (function(it){
        return it in require.extensions;
      }), path.extname
    ]))(
    fs.readdirSync(dir))));
  };
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
  function compose$(fs){
    return function(){
      var i, args = arguments;
      for (i = fs.length; i > 0; --i) { args = [fs[i-1].apply(this, args)]; }
      return args[0];
    };
  }
}).call(this);

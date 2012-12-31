(function(){
  var Matcher, StringMatcher, out$ = typeof exports != 'undefined' && exports || this, slice$ = [].slice;
  Matcher = require('../matcher').Matcher;
  out$.StringMatcher = StringMatcher = (function(superclass){
    var prototype = extend$((import$(StringMatcher, superclass).displayName = 'StringMatcher', StringMatcher), superclass).prototype, constructor = StringMatcher;
    function StringMatcher(path){
      var this$ = this instanceof ctor$ ? this : new ctor$;
      this$.path = path;
      this$.params = [];
      this$.reg = partialize$(RegExp, [void 8, 'i'], [0])(
      function(it){
        return ("^" + it) + ('/' === last(path) ? '' : '$');
      }(
      path.replace(/:([a-z$_][a-z0-9$_]*)/i, function(m, param){
        this$.params.push(param);
        return '([^\\/]+)';
      })));
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    StringMatcher.supports = function(it){
      return typeof it === 'string';
    };
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
  }(Matcher));
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
  function partialize$(f, args, where){
    return function(){
      var params = slice$.call(arguments), i,
          len = params.length, wlen = where.length,
          ta = args ? args.concat() : [], tw = where ? where.concat() : [];
      for(i = 0; i < len; ++i) { ta[tw[0]] = params[i]; tw.shift(); }
      return len < wlen && len ? partialize$(f, ta, tw) : f.apply(this, ta);
    };
  }
}).call(this);

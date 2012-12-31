(function(){
  var requireAll, Matcher, out$ = typeof exports != 'undefined' && exports || this;
  requireAll = require('./meta').requireAll;
  out$.Matcher = Matcher = (function(){
    Matcher.displayName = 'Matcher';
    var prototype = Matcher.prototype, constructor = Matcher;
    Matcher.subclasses = [];
    Matcher.extended = bind$(Matcher.subclasses, 'push');
    Matcher.create = function(spec){
      var that;
      if (that = find(function(it){
        return it.supports(spec);
      }, this.subclasses)) {
        return that(spec);
      } else {
        throw new TypeError("No matchers can handle " + spec + ".");
      }
    };
    function Matcher(){
      var this$ = this instanceof ctor$ ? this : new ctor$;
      throw new TypeError(this$.constructor.displayName + " is abstract and can't be instantiated.");
      return this$;
    } function ctor$(){} ctor$.prototype = prototype;
    prototype.match = function(){
      throw new TypeError(this.constructor.displayName + " does not implement match");
    };
    prototype.extract = function(){
      throw new TypeError(this.constructor.displayName + " does not implement extract");
    };
    return Matcher;
  }());
  requireAll("./matchers");
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
}).call(this);

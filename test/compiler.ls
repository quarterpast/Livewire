require! {
	'../test'
	'../lib/compiler'.compile-path
	Option: \fantasy-options
}

test do
	"compiler should be a curried function": do
		(compile-path '/') instanceof Function
	"compiler should return an Option": do
		((compile-path '/') '/') instanceof Option
	"compiler should return Some on matching path": do
		((compile-path '/') '/') instanceof Option.Some
	"compiler should return None on nonmatching path": do
		((compile-path '/') '/nope') is Option.None
	"the some contains params": do
		((compile-path '/:param') '/value').x.param is 'value'
	"trailing slash matches": do
		((compile-path '/trail/') '/trail') instanceof Option.Some
	"trailing slash implies prefix": do
		((compile-path '/trail/') '/trail/path') instanceof Option.Some
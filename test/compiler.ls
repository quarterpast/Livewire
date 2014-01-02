require! {
	'../test'
	'../lib/compiler'.compile-path
	Option: \fantasy-options
}

test do
	"compiler should be a curried function": do
		(compile-path '/') instanceof Function
	"compiler should return an Option": do
		((compile-path '/') url:'/') instanceof Option
	"compiler should return Some on matching path": do
		((compile-path '/') url:'/') instanceof Option.Some
	"compiler should return None on nonmatching path": do
		((compile-path '/') url:'/nope') is Option.None
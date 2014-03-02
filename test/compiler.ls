require! {
	'karma-sinon-expect'.expect
	'../lib/compiler'.compile-path
	Option: \fantasy-options
}

export
	"compiler should be a curried function": ->
		expect (compile-path '/') .to.be.a Function
	"compiler should return an Option": ->
		expect ((compile-path '/') '/') .to.be.an Option
	"compiler should return Some on matching path": ->
		expect ((compile-path '/') '/') .to.be.an Option.Some
	"compiler should return None on nonmatching path": ->
		expect ((compile-path '/') '/nope') .to.be Option.None
	"the some contains params": ->
		expect ((compile-path '/:param') '/value').x.param .to.be 'value'
	"trailing slash matches": ->
		expect ((compile-path '/trail/') '/trail') .to.be.an Option.Some
	"trailing slash implies prefix": ->
		expect ((compile-path '/trail/') '/trail/path') .to.be.an Option.Some
	"path trailing slash doesn't matter": ->
		expect ((compile-path '/path') '/path/') .to.be.an Option.Some
	"path trailing slash doesn't matter (trailing slash)": ->
		expect ((compile-path '/path/') '/path/') .to.be.an Option.Some
require! {
	'karma-sinon-expect'.expect
	'../lib/route'.route
	'fantasy-options'.Some
	'fantasy-options'.None
	'fantasy-promises'.Promise
}

# export
# 	"Route":
# 		"calls fallback if empty list": ->
# 			fallback = expect.sinon.stub!
# 			fallback.returns Promise.of "hello"
# 			fb = route fallback, []
# 			console.log f
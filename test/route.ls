require! {
	'karma-sinon-expect'.expect
	'../lib/route'.route
	'fantasy-options'.Some
	'fantasy-options'.None
}

export
	"Route":
		"calls fallback if empty list": ->
			fallback = expect.sinon.stub!
			fallback.returns "hello"
			res = route fallback, []
			expect res! .to.be "hello"
			expect fallback .to.be.called!

		"calls first match": ->
			rt = expect.sinon.stub!
			rt.returns Some "hello"
			res = route (->), [rt]

			expect res "world" .to.be "hello"
			expect rt .to.be.called-with "world"

		"calls first match when multiple": ->
			rt = expect.sinon.stub!
			rt.returns Some "hello"
			res = route (->), [(-> None), rt]

			expect res "world" .to.be "hello"
			expect rt .to.be.called-with "world"

		"calls fallback if no match": ->
			fallback = expect.sinon.stub!
			fallback.returns "hello"
			res = route fallback, [-> None]

			expect res! .to.be "hello"
			expect fallback .to.be.called!
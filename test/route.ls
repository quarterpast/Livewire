require! {
	'../test'
	'../lib/route'.route
	'fantasy-options'.Some
	'fantasy-options'.None
}

test do
	"calls fallback if empty list": (done)->
		do route do
			-> done null true
			[]
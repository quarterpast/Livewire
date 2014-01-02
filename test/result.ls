require! {
	'../test'
	'../lib'.Result
}

test do
	"constructor": new Result instanceof Result
	"newless constructor": Result! instanceof Result
	"fail": false

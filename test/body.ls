require! {
	'../test'
	'../lib/body'.body-params
	stream.Readable
	\fantasy-streams
}

create-request = (str)->
	(Readable.of str) import headers: 'content-length': str.length
id = -> it

test do
	"returns an either transformed promise": do
		(body-params id, create-request "hello").run.fork instanceof Function
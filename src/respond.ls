{Some, None} = require \fantasy-options
{compile-path} = require './compiler'

guard = (cond)->
	if cond then Some null else None

# respond :: Method → Path → (Request → Promise Response) → Request → Option Promise Response
module.exports = respond = (method, path, responder)-->
	lower = method.to-lower-case!
	extract = compile-path path
	(request)->
		<- guard lower is request.method.to-lower-case! .chain
		params <- extract request.url .chain
		Some responder request import {params}

for m in <[get post put delete patch options head trace connect]>
	module.exports[m] = respond m

# ignore curry in coverage
/* istanbul ignore next */
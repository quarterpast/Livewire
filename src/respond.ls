{compile-path} = require './compiler'
σ = require \highland

guard = (cond)->
	if cond then σ [null] else σ []

# respond :: Method → Path → (Request → Promise Response) → Request → Option Promise Response
module.exports = respond = (method, path, responder)-->
	lower = method.to-lower-case!
	extract = compile-path path
	(request)->
		<- guard lower is request.method.to-lower-case! .flat-map
		params <- extract request.url .flat-map
		responder request import {params, route:path}

for m in <[get post put delete patch options head trace connect]>
	module.exports[m] = respond m

# ignore curry in coverage
/* istanbul ignore next */

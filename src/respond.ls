{Some, None} = require \fantasy-options
{compile-path} = require './compiler'

guard = (cond)->
	if cond then Some null else None

# respond :: Method → Path → (Request → Promise Response) → Request → Option (Request → Promise Response)
export respond = (method, path, responder)-->
	extract = compile-path path
	(request)-->
		<- guard request.method is method .chain
		params <- extract request .chain
		Some (req)-> responder req import {params}

for m in <[get post put delete patch options head trace connect]>
	exports[m] = respond m

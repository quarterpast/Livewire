{Some, None} = require \fantasy-options
{compile-path} = require './compiler'

guard = (M, cond)-->
	if cond then Some() else None

# respond :: Method → Path → (Request → Promise Response) → Request → Option (Request → Promise Response)
export respond = (method, path, responder)-->
	extract = compile-path path
	(request)-->
		<- guard request.method is method .chain
		params <- extract request
		Some (req)-> responder req import {params}

exports import do
	<[ get post put delete patch options head trace connect ]>
	.reduce do
		(o, method)-> o[method] = respond method
		{}


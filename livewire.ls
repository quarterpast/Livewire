sync = require \sync

respond(method,path,func)=
	path.replace /:([a-z$_][a-z0-9$_]*)/i,//$


module.exports = require \http .create-server (req,res)->
	sync ->
		filter (.match req.path),respond
		|> fold1 (out,route)->route.sync req,res,out
		|> res.end _,\utf8

<[any get post put delete options trace patch connect head]>
|> map (method)->exports[method] = respond method

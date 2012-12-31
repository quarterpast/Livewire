require! [fs,path,callsite]

export function delegate methods,unto
	methods |> map ((method)->(method): ->@[unto][method] ...) |> fold1 (import)

export instance-tracker = (constr)->->
	obj = constr ...
	@constructor[]instances.push obj
	obj

export require-all = (dir)->
	dir = __stack.1.get-file-name!
	|> path.dirname
	|> path.resolve _,dir

	fs.readdir-sync dir
	|> filter (path.extname)>>(of require.extensions)
	|> map (path.join dir,_)>>require
	|> fold (import),{}
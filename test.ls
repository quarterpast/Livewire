module.exports = ->
	for let k,v of it =>
		if typeof v is \function
			c = set-timeout (-> console.assert no "timeout #k"), 2000
			e,r <- v
			clear-timeout c
			console.assert not e, "#k error #e"
			console.assert r,k
		else
			console.assert v,k
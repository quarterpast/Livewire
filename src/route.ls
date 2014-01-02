{Some, None} = require \fantasy-options

# compact :: [a → Option b] → a → Option B
compact = (rs, a)-->
	| rs.length is 0 => None
	| (o = rs.0 a) instanceof Some => o
	| otherwise => compact (rs.slice 1), a

id = -> it

# route :: (Option Promise Response → Promise Response) → [Request → Option Promise Response] → Request → Promise Response
export route = (fallback, rs)->
	(compact rs) >> (.fold id, fallback)

{Some, None} = require \fantasy-options

# compact :: [a → Option b] → a → Option b
compact = (rs, a)-->
	| rs.length is 0 => None
	| (o = rs.0 a) instanceof Some => o
	| otherwise => compact (rs.slice 1), a

id = -> it

# route :: (() → b) → [a → Option b] → a → b
exports.route = (fallback, rs)->
	(compact rs) >> (.fold id, fallback)

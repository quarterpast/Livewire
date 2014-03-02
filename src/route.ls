{Some, None} = require \fantasy-options

# compact :: [a → Option b] → a → Option b
compact = (rs)-> (a)->
	| rs.length is 0 => None
	| (o = rs.0 a) instanceof Some => o
	| otherwise => (compact rs.slice 1) a

# route :: (() → b) → [a → Option b] → a → b
exports.route = (fallback, rs)-->
	(compact rs) >> (.get-or-else fallback)

# ignore curry in coverage
/* istanbul ignore next */
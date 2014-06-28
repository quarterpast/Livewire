σ = require \highland

# route :: [a → Stream] → a → Stream
exports.route = (fns, req)-->
	fns.reduce do
		(acc, fn)->
			acc.otherwise fn req
		σ []

# ignore curry in coverage
/* istanbul ignore next */

σ = require \highland

exports.handle-exception = (f)-> ->
	try σ [f ...]
	catch e => σ (push, next)-> push e; next!


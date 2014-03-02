module.exports = {
	... require './body'
	... require './error'
	... require './respond'
	... require './result'
	Result: require './result'
	... require './route'
}

# ignore import in coverage
/* istanbul ignore next */
module.exports = {
	... require './body'
	... require './error'
	... require './respond'
	... require './route'
}

# ignore import in coverage
/* istanbul ignore next */

σ = require \highland
get-body = σ.wrap-callback require \raw-body
{handle-exception} = require './error'
qs = require \qs

# body-params :: (String → Stream Params) → Request → Stream Params
exports.body-params = (parser, req)-->
	get-body req, {
		length: req.headers.'content-length'
		encoding: \utf8
		limit: \1mb
	} .flat-map parser

exports.json-parse = handle-exception JSON.parse
exports.query-parse = handle-exception qs.parse

exports.json  = exports.body-params exports.json-parse
exports.query = exports.body-params exports.query-parse
exports.raw   = exports.body-params -> σ [it]

# ignore curry in coverage
/* istanbul ignore next */

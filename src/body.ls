async = require \fantasy-async
get-body = async require \raw-body
{EitherT, Left} = require \fantasy-eithers
Promise = require \fantasy-promises
{handle-exception} = require './error'
qs = require \qs

EitherPromise = EitherT Promise

# body-params :: (String → EitherPromise Error Params) → Request → EitherPromise Error Params
exports.body-params = (parser, req)-->
	get-body req, {
		length: req.headers.'content-length'
		encoding: \utf8
		limit: \1mb
	} .chain parser

exports.json-parse = EitherPromise . Promise.of . handle-exception JSON.parse
exports.query-parse = EitherPromise . Promise.of . handle-exception qs.parse

exports.json  = exports.body-params exports.json-parse
exports.query = exports.body-params exports.query-parse
exports.raw   = exports.body-params EitherPromise.of

# ignore curry in coverage
/* istanbul ignore next */
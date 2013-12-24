l = require \livewire

module.exports = l.route do
	l.get '/' -> l.ok "hello world"
	l.get '/user/#id' (req)->
		User.get req.params.id
		.map template.render
		.chain l.ok
	l.respond \PATCH '/user/#id' ->
		User.get req.params.id
		.chain ->
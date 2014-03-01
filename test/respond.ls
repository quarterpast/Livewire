require! {
	'karma-sinon-expect'.expect
	'../lib/respond'
}

export
	"should create dsl methods": ->
		expect respond
		.to.have.keys <[get post put delete patch options head trace connect]>
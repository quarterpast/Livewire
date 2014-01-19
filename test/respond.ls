require! {
	'../test'
	'../lib/respond'
}

test do
	"should create dsl methods": do
		<[get post put delete patch options head trace connect]>.every (of respond)
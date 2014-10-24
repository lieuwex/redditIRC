irc = require "irc"
request = require "request"
moment = require "moment"

client = new irc.Client "irc.awfulnet.org", "redditIRC", channels: [  ] # Channels here

setTimeout ( ->
	client.say "NickServ", "identify xxxxxxxxxxx"
), 500

client.addListener "error", (msg) -> console.log msg

client.addListener "message", (from, to, message) ->
	return unless message.toLowerCase().indexOf("@reddit") is 0
	return unless message.split(" ").length is 2
	username = message.split(" ")[1]

	request "http://www.reddit.com/user/#{username}/about.json", (req, data, res) ->
		try
			data = JSON.parse(res).data
			client.notice from, "Name: #{data.name} | Signup: #{moment(data.created * 1000).fromNow()} | LinkKarma: #{data.link_karma} |  CommentKarma: #{data.comment_karma} | Has gold: #{if data.is_gold then "yup!" else "nope"}"
		catch
			client.notice from, "Whoops! That didn't go right!"	
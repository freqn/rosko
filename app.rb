require 'sinatra'
require 'httparty'
require 'json'

before do
	content_type :txt
	@defeat = {rock: :scissors, scissors: :paper, paper: :rock}
	@throws = @defeat.keys
  @commands = {
    help: "Obviously lists what I can do",
    wink: "Try it out",
    paper: "You throw paper",
    rock: "You throw a rock",
    scissors: "You throw paper"
  }
end


get '/rosko' do
  postback(params[:text], params[:channel_id])
  status 200
end

def postback(message, channel)
  case message
  when "paper" then
    message = paper_rock_scissors("paper")
  when "rock" then
    message = paper_rock_scissors("rock")
  when "scissors" then
    message = paper_rock_scissors("scissors")
  when "wink" then
    message = "Dogs wink too."
  when "pizza" then
    message = "http://38.media.tumblr.com/tumblr_m5f7td0RmC1rnov8io1_500.gif"
  when "help" then
    message = "Type `/rosko` followed by one of these:\n\n`help` - Obviously tells you what I can do \n`wink` - I do that occasionally \n`paper` - Throw paper \n`rock` - Throw a rock \n`scissors` - Throw scissors \n`pizza` - How about a pizza gif?"
  else
    message = "Umm.. I don't know how to do that. Type `/rosko help` to see what I can do"
  end
  slack_webhook = ENV['SLACK_WEBHOOK_URL']
  HTTParty.post slack_webhook, body: {"text" => message.to_s, "username" => "Rosko", "channel" => params[:channel_id]}.to_json, headers: {'content-type' => 'application/json'}
end


def paper_rock_scissors(player_throw)
  @player_throw = player_throw.to_sym
  @computer_throw = @throws.sample

  if !@throws.include?(player_throw.to_sym)
		"You must throw one of the following `paper`, `rock` or `scissors`"
	end

  if @player_throw == @computer_throw
		"I also thew #{@computer_throw}, so try again."
	elsif @computer_throw == @defeat[@player_throw]
		"Nicely done! Your #{@player_throw} beats my #{@computer_throw}!"
	else
		"Ouch, my #{@computer_throw} beats your #{@player_throw}. Better luck next time!"
	end
end

def rosko_commands
  @commands = {
    help: "Obviously lists what I can do",
    wink: "Try it out",
    paper: "You throw paper",
    rock: "You throw a rock",
    scissors: "You throw paper"
  }
end

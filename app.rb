require 'sinatra'
require 'httparty'
require 'json'
load 'pizza.rb'

get '/rosko' do
  postback(params[:text], params[:channel_id])
  status 200
end

def postback(message, channel)
    case message
    when "wink" then
      message = "Dogs wink too."
    when "pizza" then
      message = @pizzas.sample
    when "help" then
      message = "`/rosko wink` is my only command, but stay tuned because every office puppy learns new tricks."
    else
      message = "Umm.. I don't know how to do that. Type `/rosko help` to see what I can do"
    end
    slack_webhook = ENV['SLACK_WEBHOOK_URL']
    HTTParty.post slack_webhook, body: {"text" => message.to_s, "username" => "Rosko", "channel" => params[:channel_id]}.to_json, headers: {'content-type' => 'application/json'}
end

require 'rubygems'
require 'sinatra'
require 'httpclient'
require_relative 'skillqueue'

# TODO
# Handle Timezones (if necessary)
# Custom 404 and others
# Front matter (theme by, github link etc)

get '/' do
  File.read(File.join('public', 'index.html'))
end


get '/calendar/:keyID/:vCode/:characterID/calendar.ics' do

  show_calendar = params[:calendar] != 'no'
  show_queue = params[:showQueue] != 'no'
  show_reminder = params[:queusEmptyReminder] != 'no'
  reminder_time = params[:defaultReminder].to_i

  skill_queue = SkillQueue.new(params[:keyID], params[:vCode], params[:characterID])
  skill_queue.create_events if show_queue
  skill_queue.create_reminder if show_reminder

  skill_queue.calendar
end

before '/calendar/*' do
  response.headers['Content-Type'] = 'text/calendar'
end

get '/test/:pram/test.ics' do
    "PRAM: #{params[:pram]} frist #{params[:frist1]} frist #{params[:frist2]}."
end

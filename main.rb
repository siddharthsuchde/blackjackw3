require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

set :sessions, true

helpers do
	def calculate (cards)
		arr = cards.map {|e| e[1]}
		# new array of cards with 
		total = 0
		arr.each do |value|
			if value.to_i == 0 && value !=  'Ace'
				total += 10
			elsif value.to_i == 0 && value == 'Ace'
				total += 11
			else
				total += value.to_i
			end
		end
	# correct for Aces : glanced at solutions for this step!
		if arr.include?('Ace') && total > 21
		total -= 10
		end
		total
	end
end

before do
	@show_hit_stay_buttons = true
end



get '/' do
	redirect '/new_game'
end

get '/new_game' do
	erb :username
end

post '/bet' do
	#param hash much grab input forms VALUE
	#in .erb file under <input> element
	#key/value pair. Grab value
	#param hash is not like session
	#it get's reset on every request
	#sessions action is like a cookie
	

	session[:name] = params[:name]
	erb :bet
end

post '/game' do
	#create a deck and put it in session
	session[:name]
	session[:bet] = params[:bet]
	faces = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)
	suits = %w(Spades Hearts Clubs Diamonds)

	#deal cards
	session[:player]= []
	session[:dealer]= []
	session[:deck] = suits.product(faces).shuffle!
	session[:player] << session[:deck].pop
	session[:dealer] << session[:deck].pop
	session[:player] << session[:deck].pop
	session[:dealer] << session[:deck].pop


	
	session[:player_total] = calculate(session[:player])
	session[:dealer_total] = calculate(session[:dealer])

	erb :game
end

post '/game/player/hit' do
	session[:player] << session[:deck].pop
	session[:player_total] = calculate(session[:player])
	if calculate(session[:player]) > 21
		@error = "Sorry, your bust! You lose"
		@show_hit_stay_buttons = false
	end
	#want to render the same original game template
	erb :game
end

post '/game/player/stay' do
	@show_hit_stay_buttons = false
	@success = "The Player decides to stay"

	erb :game
end













	





















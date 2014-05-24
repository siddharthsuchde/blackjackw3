require 'rubygems'
require 'sinatra'
#need this to refresh instead of restarting server
#similar to "shotgun" in Mac OS
require 'sinatra/reloader'

set :sessions, true

#methods which can be used in main.rb file and all view templates
#place all common methods here
helpers do
	#taken from procedural blackjack game
	def calculate (cards)
		arr = cards.map {|e| e[1]}
		# new array of cards with 
		total = 0
		arr.each do |value|
			if value.to_i == 0 && value !=  'A'
				total += 10
			elsif value.to_i == 0 && value == 'A'
				total += 11
			else
				total += value.to_i
			end
		end
	# correct for Aces : glanced at solutions for this step!
		if arr.include?('A') && total > 21
		total -= 10
		end
		total
	end

	def card_images(cards)
		#[[H,2], [S,8]] => cards will be "popped" like this.
		suit = case cards[0]
			when "H" then "hearts"
			when "D" then "diamonds"
			when "S" then "spades"
			when "C" then "clubs"
		end

		value = cards[1] 
		if ['J','Q','K','A'].include?(value)
			value = case cards[1]
			when "J" then "jack"
			when "Q" then "queen"
			when "K" then "king"
			when "A" then "ace"
			end
		end
		"<img src='/images/cards/#{suit}_#{value}.jpg' class='card_image'>"
	end
end



#this code will be run in every HTTP request below
#it will be the first piece of code to be run
before do
	@show_hit_stay_buttons = true
	@dealer_hit_button = false
	@startover_button = false
end



get '/' do
	#if session[:name]
		#redirect '/game'
	#else
	redirect '/new_game'
	#end
end

get '/new_game' do
	erb :username
end

#post '/new_game' do
	#session[:name] = params[:name]
	#redirect '/game'
#end


#post '/bet' do
	#param hash much grab input forms VALUE
	#in .erb file under <input> element
	#key/value pair. Grab value
	#param hash is not like session
	#it get's reset on every request
	#sessions action is like a cookie
	

	#session[:name] = params[:name]
	#erb :bet
#end

post '/game' do
	session[:name] = params[:name]
	session[:turn] = session[:name]
	#create a deck and put it in session
	
	#session[:bet] = params[:bet]
	faces = %w(2 3 4 5 6 7 8 9 10 J Q K A)
	suits = %w(S H C D)

	#deal cards
	#same logic as procedural game except have to save
	#values in sessions. create an artificial database
	session[:player]= []
	session[:dealer]= []
	session[:deck] = suits.product(faces).shuffle!
	session[:player] << session[:deck].pop
	session[:dealer] << session[:deck].pop
	session[:player] << session[:deck].pop
	session[:dealer] << session[:deck].pop


	
	session[:player_total] = calculate(session[:player])
	session[:dealer_total] = calculate(session[:dealer])

	if session[:player_total] == 21
		@success = "Congrats! Blackjack. You win!"
		@show_hit_stay_buttons = false
	elsif session[:dealer_total] == 21
		@show_hit_stay_buttons = false
		@error = "Dealer Hits Blackjack. Dealer wins! Sorry Better Luck Next Time!"
	elsif session[:player_total] && session[:dealer_total] == 21
		@success = "Player and Dealer hit Blackjack! It's a tie!"
		@show_hit_stay_buttons = false 
	end 

	erb :game
end

#when a player hits it's redirected here
post '/game/player/hit' do
	session[:player] << session[:deck].pop
	session[:player_total] = calculate(session[:player])
	if calculate(session[:player]) == 21
		@success = "Congrations! Blackjack. You win!!"
		@show_hit_stay_buttons = false
		@startover_button = true
	elsif calculate(session[:player]) > 21
		@error = "Sorry, your bust! You lose"
		#buttons disappear when total > 21 as set to false
		@show_hit_stay_buttons = false
		@startover_button = true
	end
	#want to render the same original game template
	erb :game
end

post '/game/player/stay' do
	session[:turn] = "Dealer"
	#before do code here. set to false to hide <form> buttons
	#when user clicks "Stay" button on :game template
	@show_hit_stay_buttons = false
	

	if calculate(session[:dealer]) > calculate(session[:player])
		@error = "Sorry! Dealers Total is Higher. The Dealer Wins!"
		@startover_button = true
	elsif calculate(session[:dealer]) < 17 && calculate(session[:dealer]) < calculate(session[:player])
		@dealer_hit_button = true
		@success = "The Player decides to stay"
	elsif calculate(session[:dealer]) >= 17 && calculate(session[:dealer]) < calculate(session[:player])
		@success = "Players Total is Higher. The Player Wins!"
		@startover_button = true
	elsif calculate(session[:dealer]) >= 17 && calculate(session[:dealer]) == calculate(session[:player])
		@error = "Bummer, it's a tie!"
		@startover_button = true
	end

	#want to render the same original game template
	erb :game
end


post '/game/dealer/hit' do
	@show_hit_stay_buttons = false
	@dealer_hit_button = true
	#hit button should only appear when player stays
	session[:dealer] << session[:deck].pop
	session[:dealer_total] = calculate(session[:dealer])
	if calculate(session[:dealer]) == 21
		@error = "Dealer Hits Blackjack! Sorry You Lose!"
		@dealer_hit_button = false
		@startover_button = true
	elsif session[:dealer_total] > 21
		@success = "Dealer goes Bust! Congrats You Win!"
		@startover_button = true
		@dealer_hit_button = false
	elsif session[:dealer_total] >= 17 && session[:dealer_total] == session[:player_total]
		@dealer_hit_button = false
		@error = "Both Totals are Equal. It's a tie!"
		@startover_button = true
	elsif session[:dealer_total] >= 17 && session[:dealer_total] > session[:player_total]
		@dealer_hit_button = false
		@startover_button = true
		@error = "Dealers Total is Higher. Dealer Wins!"
	elsif session[:dealer_total] >= 17 && session[:dealer_total] < session[:player_total]
		@dealer_hit_button = false
		@startover_button = true
		@success = "Congrats! Your Total is higher you win!!"
	end
	
	erb :game
end 













	





















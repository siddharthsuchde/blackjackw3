$(document).ready(function() {
	player_hits();
	player_stays();
	dealer_hits();
});

//when page loads, wire up this connection
	//but when form chages it doesn't do it again
	//tell JQUERY we want to do this AJAX method EVERY TIME
	// "on" call to do that
	//on takes 3 parameters
	//on => click
	// what element are you looking for? css selector
	//anonymous function.
	// this says continuously look for the "form#hit.." element/selector
	//look for click event

function player_hits() {
	$(document).on("click", "form#hit_form input",function() {
		//can do something here. that's what a functions for
		//Jquery lets us write unobtrusive javascript
		//can mess with DOM any way we want
		//can submit ajax requests to client in any way
		//ajax syntax below
		alert("player hits!");
		$.ajax({
			type:"POST",
			url:"/game/player/hit",
			//submitting to the same form. 
			//ajax will keep URL and page the same
			//even though in the background 
			// card has been added when HIT is pressed
			//new layout will NOT appear and neither will
			//the new URL unless explicitly called as is done below
			//We want to render Game template again
			//but with the additional card once hit is pressed

		}).done(function(msg) {
			$("#game").replaceWith(msg);

		});

		return false;
	});
};

function player_stays() {
	$(document).on("click", "form#stay_form input",function() {
		
		alert("player stays!");
		$.ajax({
			type:"POST",
			url:"/game/player/stay",
		}).done(function(msg) {
		$("#game").replaceWith(msg);

		});

		return false;
	});
};

function dealer_hits() {
	$(document).on("click", "form#dealer_hit input",function() {
		
		alert("dealer hits!");
		$.ajax({
			type:"POST",
			url:"/game/dealer/hit",
		}).done(function(msg) {
		$("#game").replaceWith(msg);

		});

		return false;
	});
};




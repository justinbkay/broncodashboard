module InfoHelper
  def years_of_service(hire_date)
    days = Date.today - hire_date
    (days.to_i / 365)
  end
  
  def winner(game)
    if game.complete?
		  if game.home_score > game.visitor_score
			  winner = game.home_team.to_s 
		  else
			  winner = game.visitor_team.to_s
		  end
	  else
		  winner = '&nbsp;'
	  end
  end
  
  def score(game)
    if game.complete?
		  if game.home_score > game.visitor_score
			  winner = game.home_score.to_s + ' - ' + game.visitor_score.to_s
		  else
			  winner = game.visitor_score.to_s + ' - ' + game.home_score.to_s
		  end
	  else
		  winner = '&nbsp;'
	  end
  end
  
end

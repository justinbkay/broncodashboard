xml.instruct!
xml.players do
  @players.each do |player|
    xml.player do
      xml.number player.number
      xml.name player.name
      xml.position player.position
      xml.height player.height
      xml.weight player.weight
      xml.year player.year
      xml.hometown player.hometown
      xml.previous_school player.previous_school
    end
  end
end
class SyndicationController < ApplicationController
  caches_page :bsu_schedule_lite_plist, :bsu_schedule_plist, :roster_plist, :vandal_roster_plist, :bsu_schedule, :vandal_schedule_plist, :fresno_roster_plist, :fresno_schedule_plist, :hawaii_roster_plist, :hawaii_schedule_plist, :byu_schedule_plist, :byu_roster_plist, :byu_all_data, :bsu_all_data,
  :hawaii_all_data, :vandal_all_data

  def bsu_schedule
    @team = Team.find(1)
    @tz = get_tz
    @season = Season.find(Game::SEASON)
    @schedule = Game.where(['(home_team_id=1 OR visitor_team_id=1) AND season_id=?', Game::SEASON]).order(:game_time)

    #@headers["Content-Type"] = "application/rss+xml"
    respond_to do |format|
      format.xml
    end
  end

  def byu_schedule
    @team = Team.find(43)
    @tz = get_tz
    @season = Season.find(Game::SEASON)
    @schedule = Game.where(['(home_team_id=43 OR visitor_team_id=43) AND season_id=?', Game::SEASON]).order(:game_time)

    respond_to do |format|
      format.xml
    end
  end

  def roster
    @players = Player.active

    respond_to do |format|
      format.xml
    end

  end

  def bsu_schedule_plist
    plist = generate_schedule_plist(1,'Mountain Time (US & Canada)')
    render(:text => plist)
  end

  def bsu_schedule_lite_plist
    plist = generate_utc_schedule_plist(1)
    render(:text => plist)
  end

  def byu_schedule_plist
    plist = generate_utc_schedule_plist(43)
    render(:text => plist)
  end

  def byu_roster_plist
    plist = generate_roster_plist(43)
    render(:text => plist)
  end

  def roster_plist
    plist = generate_roster_plist(1)
    render(:text => plist)
  end

  def fresno_roster_plist
    plist = generate_roster_plist(9)
    render(:text => plist)
  end

  def fresno_schedule_plist
    plist = generate_schedule_plist(9,'Pacific Time (US & Canada)')
    render(:text => plist)
  end

  def vandal_roster_plist
    plist = generate_roster_plist(12)
    render(:text => plist)
  end

  def vandal_schedule_plist
    plist = generate_schedule_plist(12,'Pacific Time (US & Canada)')
    render(:text => plist)
  end

  def hawaii_roster_plist
    plist = generate_roster_plist(13)
    render(:text => plist)
  end

  def hawaii_schedule_plist
    plist = generate_schedule_plist(13,'Hawaii')
    render(:text => plist)
  end

  # utc schedules
  def hawaii_schedule_utc_plist
    plist = generate_utc_schedule_plist(13)
    render(:text => plist)
  end

  def vandal_schedule_utc_plist
    plist = generate_utc_schedule_plist(12)
    render(:text => plist)
  end

  def fresno_schedule_utc_plist
    plist = generate_utc_schedule_plist(9)
    render(:text => plist)
  end

  def byu_all_data
    all_data = {}
    poll_path = File.expand_path(Rails.root) + '/public/polls_dump'
    all_data['polls'] = Marshal.load(File.read(poll_path))
    all_data['roster'] = generate_roster_hash(43)
    all_data['schedule'] = generate_utc_schedule_hash(43)
    plist = Plist::Emit.dump(all_data)
    render(:text => plist)
  end

  def bsu_all_data
    all_data = {}
    poll_path = File.expand_path(Rails.root) + '/public/polls_dump'
    all_data['polls'] = Marshal.load(File.read(poll_path))
    all_data['roster'] = generate_roster_hash(1)
    all_data['schedule'] = generate_utc_schedule_hash(1)
    plist = Plist::Emit.dump(all_data)
    render(:text => plist)
  end

  def hawaii_all_data
    all_data = {}
    poll_path = File.expand_path(Rails.root) + '/public/polls_dump'
    all_data['polls'] = Marshal.load(File.read(poll_path))
    all_data['roster'] = generate_roster_hash(13)
    all_data['schedule'] = generate_utc_schedule_hash(13)
    plist = Plist::Emit.dump(all_data)
    render(:text => plist)
  end

  def vandal_all_data
    all_data = {}
    poll_path = File.expand_path(Rails.root) + '/public/polls_dump'
    all_data['polls'] = Marshal.load(File.read(poll_path))
    all_data['roster'] = generate_roster_hash(12)
    all_data['schedule'] = generate_utc_schedule_hash(12)
    plist = Plist::Emit.dump(all_data)
    render(:text => plist)
  end

private

  def generate_schedule_plist(team,tz)
    @schedule = Game.where(['(home_team_id=? OR visitor_team_id=?) AND season_id=?', team, team, Game::SEASON]).order(:game_time)
    plist_array = []
    @schedule.each do |game|
      if game.home_team_id == team
        opponent = game.visitor_team_ranked

        if game.visitor_team.conference_id == team
          opponent += '*'
        end

        if game.complete?
          score = "#{game.home_score} - #{game.visitor_score}"
          result = game.home_score > game.visitor_score ? "W" : "L"
        else
          if game.tba?
            score = game.game_time.to_s(:day) + ' ' + 'TBA' unless game.game_time.nil?
          else
            score = game.game_time.to_s(:day) + ' ' + game.game_time.in_time_zone(tz).to_s(:time) unless game.game_time.nil?
          end
          result = " "
        end
      else
        opponent = "@" + game.home_team_ranked

        if game.home_team.conference_id == team
          opponent += '*'
        end

        if game.complete?
          score = "#{game.visitor_score} - #{game.home_score}"
          result = game.visitor_score > game.home_score ? "W" : "L"
        else
          if game.tba?
            score =  game.game_time.to_s(:day) + ' ' + 'TBA' unless game.game_time.nil?
          else
            score = game.game_time.to_s(:day) + ' ' + game.game_time.in_time_zone(tz).to_s(:time) unless game.game_time.nil?
          end
          result = " "
        end

      end
	  media = game.media.empty? ? ' ' : game.media


      plist_array << {'date' => score, 'opponent' => opponent, 'tv' => media, 'result' => result}
    end

    plist = Plist::Emit.dump(plist_array)
  end

  def generate_utc_schedule_plist(team)
    plist = Plist::Emit.dump(generate_utc_schedule_hash(team))
  end

  def generate_utc_schedule_hash(team)
    @schedule = Game.where(['(home_team_id=? OR visitor_team_id=?) AND season_id=?',team,team,Game::SEASON]).order(:game_time)
    @team = Team.find(team)
    plist_array = []
    @schedule.each do |game|
      # tba is only one
      tba = game.tba? ? "T" : "F"
      complete = game.complete? ? "T" : "F"
      game_time = game.game_time
      media = game.media.empty? ? ' ' : game.media

      if game.home_team_id == team
        opponent = game.visitor_team_ranked

        if game.visitor_team.conference_id == Team.find(team).conference_id
          opponent += '*'
        end

        if game.complete?
          score = "#{game.home_score} - #{game.visitor_score}"
          result = game.home_score > game.visitor_score ? "W" : "L"
        else
          score = ""
          result = ""
        end
      else
        opponent = "@" + game.home_team_ranked

        if game.home_team.conference_id == Team.find(team).conference_id
          opponent += '*'
        end

        if game.complete?
          score = "#{game.visitor_score} - #{game.home_score}"
          result = game.visitor_score > game.home_score ? "W" : "L"
        else
          score =  ""
          result = ""
        end
      end
	    website_id = game.website_id || ""
      plist_array << {'id' => game.id, 'website_id' => website_id, 'record' => "#{@team.record} (#{@team.conference_record})", 'tba' => tba, 'complete' => complete, 'score' => score, 'game_time' => game_time, 'opponent' => opponent, 'tv' => media, 'result' => result}
    end
    return plist_array
  end


  def generate_roster_plist(team)
    plist = Plist::Emit.dump(generate_roster_hash(team))
  end

  def generate_roster_hash(team)
     @players = Player.all(:conditions => ['team_id=? AND active=1',team], :order => 'number')
    plist_hash = []

    @players.each do |p|
      plist_hash << {'number' => p.number,
                     'name' => p.name.chomp,
                     'position' => p.position,
                     'year' => p.year,
                     'height' => p.height,
                     'weight' => p.weight,
                     'hometown' => p.hometown,
                     'years_rostered' => p.years_rostered,
                     'website_key' => p.website_key,
                     'previous_school' => p.previous_school,
                     'url' => p.url}
    end
    return plist_hash
  end

end

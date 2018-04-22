require 'httpclient'
require 'json'
require 'shift_stats/configuration'

class ShiftStats
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def initialize
    @url_base = 'http://api.shiftstats.com/'
    @ticket_hash = nil

    @client = HTTPClient.new
    @client.transparent_gzip_decompression = true

    response = @client.get(url('login'), query: login_query, header: basic_headers)
    response_json = JSON.parse(response.body) if response
    if response_json && response_json['ticket'] && response_json['ticket']['hash']
      @ticket_hash = response_json['ticket']['hash']
    else
      if response && response.body
        raise response.body
      else
        raise "Unknown error. Make sure you have an internet connection and your API key is correct."
      end
    end
  end

  def leagues()
    JSON.parse(@client.get(url('leagues'), header: headers).body)
  end

  def league(league_id)
    JSON.parse(@client.get(url("league/#{league_id}"), header: headers).body)
  end

  def league_seasons(league_id)
    JSON.parse(@client.get(url("league/#{league_id}/seasons"), header: headers).body)
  end

  def league_suspensions(league_id, only_active: true)
    query = {}
    if only_active
      query[:status] = 'active'
    end
    JSON.parse(@client.get(url("league/#{league_id}/suspensions"), query: query, header: headers).body)
  end

  def team_search(sport, name)
    JSON.parse(@client.get(url('teams'), query: {name: name, not_ended: true, sport: sport.downcase}, header: headers).body)
  end

  def team_schedule(team_id)
    JSON.parse(@client.get(url("team/#{team_id}/games"), query: {future: true, today: true, past: true}, header: headers).body)
  end

  def team_players_list(team_id)
    JSON.parse(@client.get(url("team/#{team_id}/players"), query: {status: 'active'}, header: headers).body)
  end

  def teams_in_division(division_name, league_id, current_season: true)
    JSON.parse(@client.get(url('teams'), query: {division: division_name, league_id: league_id, not_ended: !!current_season}, header: headers).body)
  end

  def team_games(team_id, include_future: true, include_today: true)
    JSON.parse(@client.get(url("team/#{team_id}/games"), query: {future: include_future, today: include_today}, header: headers).body)
  end

  def team_games_for_status(team_id, status: 'Final,In Progress,Forfeit')
    JSON.parse(@client.get(url("team/#{team_id}/games"), query: {status: status}, header: headers).body)
  end

  def team_practices(team_id, include_future: true, include_today: true)
    JSON.parse(@client.get(url("team/#{team_id}/practices"), query: {future: include_future, today: include_today}, header: headers).body)
  end

  def team_suspensions(team_id, only_active: true)
    query = {}
    if only_active
      query[:status] = 'active'
    end
    JSON.parse(@client.get(url("team/#{team_id}/suspensions"), query: query, header: headers).body)
  end

  def game(game_id)
    JSON.parse(@client.get(url("game/#{game_id}"), header: headers).body)
  end

  # only is :home or :away, optional
  def game_goals(game_id, only: nil)
    game_subpath(game_id, 'goals', only)
  end

  # only is :home or :away, optional
  def game_goalies(game_id, only: nil)
    game_subpath(game_id, 'goalies', only)
  end

  # only is :home or :away, optional
  def game_penalties(game_id, only: nil)
    game_subpath(game_id, 'penalties', only)
  end

  # only is :home or :away, optional
  def game_roster(game_id, only: nil)
    game_subpath(game_id, 'roster', only)
  end

  def division_games_list(division_id)
    JSON.parse(@client.get(url("division/#{division_id}/games"), header: headers).body)
  end

  # type is 'Regular Season', 'Playoffs', or 'Exhibition', required
  def division_standings(division_id, type: 'Regular Season')
    JSON.parse(@client.get(url("division/#{division_id}/standings"), query: {type: type}, header: headers).body)
  end

  def division_teams(division_id)
    JSON.parse(@client.get(url("division/#{division_id}/teams"), header: headers).body)
  end

  # type is 'Regular Season', 'Playoffs', or 'Exhibition', required
  # limit, required
  # metrics, required
  def division_leaders(division_id, type: 'Regular Season', limit: 20, metrics: [:points, :goals, :assists, :goals_against_average, :save_percentage, :wins, :shutouts, :number_first_stars, :number_stars])
    JSON.parse(@client.get(url("division/#{division_id}/leaders"), query: {limit: limit, metrics: metrics.join(','), type: type}, header: headers).body)
  end

  def division_suspensions(division_id, only_active: true)
    query = {}
    if only_active
      query[:status] = 'active'
    end
    JSON.parse(@client.get(url("division/#{division_id}/suspensions"), query: query, header: headers).body)
  end

  def season(season_id)
    JSON.parse(@client.get(url("season/#{season_id}"), header: headers).body)
  end

  def season_divisions_list(season_id)
    JSON.parse(@client.get(url("season/#{season_id}/divisions"), header: headers).body)
  end

  def season_suspensions(season_id, only_active: true)
    query = {}
    if only_active
      query[:status] = 'active'
    end
    JSON.parse(@client.get(url("season/#{season_id}/suspensions"), query: query, header: headers).body)
  end

  private
    def url(sub)
      return "#{@url_base}#{sub}"
    end

    def game_subpath(game_id, path, only)
      path = "home_#{path}" if only == :home
      path = "away_#{path}" if only == :away
      JSON.parse(@client.get(url("game/#{game_id}/#{path}"), header: headers).body)
    end

    def login_query
      {key: self.class.configuration.api_key}
    end

    def basic_headers
      {
        'Accept' => 'application/json',
        'Content-Type' => 'application/json',
        'X-Requested-With' => 'com.digitalshift.hockeyshift',
        'Accept-Language' => 'en-US',
        'Accept-Encoding' => 'gzip,deflate',
        'Connection' => 'keep-alive',
      }
    end

    def headers
      basic_headers.merge({
        'Authorization' => "StatsAuth ticket=\"#{@ticket_hash}\""
      })
    end
end

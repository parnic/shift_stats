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

  def team_search(sport, name)
    JSON.parse(@client.get(url('teams'), query: {name: name, not_ended: true, sport: sport.downcase}, header: headers).body)
  end

  def team_schedule(team_id)
    JSON.parse(@client.get(url("team/#{team_id}/games"), query: {future: true, today: true, past: true}, header: headers).body)
  end

  def team_players_list(team_id)
    JSON.parse(@client.get(url("team/#{team_id}/players"), query: {status: 'active'}, header: headers).body)
  end

  def division_games_list(division_id)
    JSON.parse(@client.get(url("division/#{division_id}/games"), header: headers).body)
  end

  def season_divisions_list(season_id)
    JSON.parse(@client.get(url("season/#{season_id}/divisions"), header: headers).body)
  end

  private
    def url(sub)
      return "#{@url_base}#{sub}"
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

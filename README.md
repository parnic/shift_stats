# ShiftStats gem
This gem pulls data from Digital Shift sites such as HockeyShift, SoccerShift, LacrosseShift, FootballShift, BasketballShift, and BaseballShift.

[![Gem Version](https://badge.fury.io/rb/shift_stats.svg)](http://badge.fury.io/rb/shift_stats)

## Install
You can install shift_stats via rubygems: `gem install shift_stats`

## Usage

```ruby
require 'shift_stats'
```

Optionally configure your API key (note: by default uses the same API key as the Android HockeyShift app)

```ruby
ShiftStats.configure do |config|
  config.api_key 'my_api_key'
end
```

Create a new instance of ShiftStats with `s = ShiftStats.new`. This connects to the ShiftStats server, logs in, and stores the ticket hash. This ticket is only valid for a limited amount of time.

Creating an instance of the class can raise an error if there are network issues or the API key is invalid.

### Available methods

* `leagues` - Get a list of all available leagues.
* `league(league_id)` - Show details for a specific league.
* `league_seasons(league_id)` - Get a list of seasons for a specific league.
* `league_suspensions(league_id, only_active: true)` - Get a list of suspended players for the specified league.
  * `only_active` controls whether expired suspensions are included or not.
  * WARNING: this response can be very large, especially if `only_active` is false.
* `team_search(sport_name, team_name)` - Search for the given team in the given sport for all active seasons.
* `team_schedule(team_id)` - Retrieve the game schedule for the supplied team.
* `team_players_list(team_id)` - Get the list of players on a specific team.
* `teams_in_division(division_name, league_id, current_season: true)` - Get all teams in the named division in the specific league.
  * This is an odd API that requires the division be a name, not an ID, and requires specifying a league ID to search in.
* `team_games(team_id, include_future: true, include_today: true)` - Get all games for a specific team.
* `team_games_for_status(team_id, status: 'Final,In Progress,Forfeit')` - Get a list of all games for a specific team matching the specified type.
  * Valid values for `status` are `Final`, `In Progress`, and `Forfeit`, and can be mixed and matched, separated by commas.
* `team_practices(team_id, include_future: true, include_today: true)` - Get a list of practices schedule for the specified team.
* `team_suspensions(team_id, only_active: true)` - Get a list of suspensions of players on the specified team.
  * `only_active` controls whether expired suspensions are included or not.
* `game(game_id)` - Returns data about the specified game.
* `game_goals(game_id, only: nil)` - Returns a list of goals in the specified game.
  * Valid values for `only` are `:home` and `:away`. If not specified, both teams' goals are included.
* `game_goalies(game_id, only: nil)` - Returns a list of goalies in the specified game.
  * Valid values for `only` are `:home` and `:away`. If not specified, both teams' goalies are included.
* `game_penalties(game_id, only: nil)` - Returns a list of penalties in the specified game.
  * Valid values for `only` are `:home` and `:away`. If not specified, both teams' penalties are included.
* `game_roster(game_id, only: nil)` - Returns the roster for the specified game.
  * Valid values for `only` are `:home` and `:away`. If not specified, both teams' rosters are included.
* `division_games_list(division_id)` - Returns all games for a specified division.
* `division_standings(division_id, type: 'Regular Season')` - Returns a ranked list of teams for the specified division.
  * Valid values for `type` are `Regular Season`, `Playoffs`, and `Exhibition`.
* `division_teams(division_id)` - Lists all teams in the specified division.
* `division_leaders(division_id, type: 'Regular Season', limit: 20, metrics: [:points, :goals])` - Lists up to `limit` number of leaders for the specified division.
  * Valid values for `type` are `Regular Season`, `Playoffs`, and `Exhibition`.
  * Valid values for `metrics` include anything listed in `league(league_id)['league']['view_settings']['leader_metrics']`.
* `division_suspensions(division_id, only_active: true)` - Get a list of suspensions of players in the specified division.
  * `only_active` controls whether expired suspensions are included or not.
* `season(season_id)` - Show details for a specific season.
* `season_divisions_list(season_id)` - Lists all divisions for the specified season.
* `season_suspensions(season_id, only_active: true)` - Get a list of suspended players for the specified season.
  * `only_active` controls whether expired suspensions are included or not.

## Bug reports, feature requests, contributions

Please create an issue or pull request on github. Assistance is most welcome.

There are more endpoints available on Shift sites, but none are documented. Running a mobile app inside an emulator and watching wireshark, fiddler, etc. is how the current endpoints were discovered.

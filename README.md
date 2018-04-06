# ShiftStats gem
This gem pulls data from Digital Shift sites such as HockeyShift, SoccerShift, LacrosseShift, FootballShift, BasketballShift, and BaseballShift.
[![Gem Version](https://badge.fury.io/rb/shift_stats.svg)](http://badge.fury.io/rb/shift_stats)

## Features
* Get details about any team for any sport
* Get a specific team's game schedule
* Retrieve the list of players on a specific team
* Find all games for a specific division
* Find all divisions in a specific season

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

Create a new instance of ShiftSats with `s = new ShiftStats`. This connects to the ShiftStats server, logs in, and stores the ticket hash. This ticket is only valid for a limited amount of time.

Creating an instance of the class can raise an error if there are network issues or the API key is invalid.

### Available methods

* `team_search(sport_name, team_name)` - Search for the given team in the given sport for all active seasons.
* `team_schedule(team_id)` - Retrieve the game schedule for the supplied team.
* `team_players_list(team_id)` - Get the list of players on a specific team.
* `division_games_list(division_id)` - Returns all games for a specified division.
* `season_divisions_list(season_id)` - Lists all divisions for the specified season.

## Bug reports, feature requests, contributions

Please create an issue or pull request on github. Assistance is most welcome.

There are many more endpoints available on Shift sites, but none are documented. Running a mobile app inside an emulator and watching wireshark, fiddler, etc. is how the current endpoints were discovered.

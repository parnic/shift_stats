require 'spec_helper'

describe ShiftStats do
  describe 'bad api key' do
    it 'throws an error' do
      ShiftStats.configure {|config| config.api_key = 'a'}
      expect {ShiftStats.new}.to raise_error RuntimeError
    end
  end

  describe 'with valid api key' do
    s = ShiftStats.new
    team_search = s.team_search('hockey', 'bears')

    context 'team_search' do
      it 'returns some teams' do
        expect(team_search).to include 'teams'
      end

      it 'finds the right team' do
        bears = team_search['teams'].select{|team| team['id'] == 18827}.first
        expect(bears).to be_truthy
      end
    end

    context 'team_schedule' do
      team_schedule = s.team_schedule(18827)

      it 'returns a schedule' do
        expect(team_schedule).to include 'games'
      end
    end

    context 'team_players_list' do
      team_players = s.team_players_list(18827)

      it 'returns players' do
        expect(team_players).to include 'players'
      end
    end

    context 'division_games_list' do
      division_games = s.division_games_list(3057)

      it 'returns a list of games' do
        expect(division_games).to include 'games'
      end
    end

    context 'season_divisions_list' do
      season_divisions = s.season_divisions_list(741)

      it 'returns a list of divisions' do
        expect(season_divisions).to include 'divisions'
      end
    end

    context 'season_suspensions' do
      ret = s.season_suspensions(741, only_active: false)

      it 'returns a list of suspensions' do
        expect(ret).to include 'suspensions'
      end
    end

    context 'leagues' do
      leagues = s.leagues

      it 'returns a list of leagues' do
        expect(leagues).to include 'leagues'
      end
    end

    context 'league' do
      league = s.league(3)

      it 'returns a league' do
        expect(league).to include 'league'
      end
    end

    context 'league_seasons' do
      seasons = s.league_seasons(3)

      it 'returns a list of seasons' do
        expect(seasons).to include 'seasons'
      end
    end

    context 'league_seasons' do
      ret = s.league_suspensions(3, only_active: true)

      it 'returns a list of suspensions' do
        expect(ret).to include 'suspensions'
      end
    end

    context 'teams_in_division' do
      teams = s.teams_in_division('XPL', 317, current_season: true)

      it 'returns a list of teams' do
        expect(teams).to include 'teams'
      end
    end

    context 'team_games' do
      games = s.team_games(1, include_future: true, include_today: true)

      it 'returns a list of games' do
        expect(games).to include 'games'
      end
    end

    context 'team_games_for_status' do
      games = s.team_games_for_status(1, status: 'Final,In Progress')

      it 'returns a list of games' do
        expect(games).to include 'games'
      end
    end

    context 'team_practices' do
      practices = s.team_practices(18827, include_future: true, include_today: true)

      it 'returns a list of practices' do
        expect(practices).to include 'practices'
      end
    end

    context 'team_suspensions' do
      ret = s.team_suspensions(18827, only_active: false)

      it 'returns a list of suspensions' do
        expect(ret).to include 'suspensions'
      end
    end

    context 'game' do
      ret = s.game(128740)

      it 'returns game info' do
        expect(ret).to include 'game'
      end
    end

    context 'game_goals' do
      ret = s.game_goals(128740, only: :away)

      it 'returns a list of away goals' do
        expect(ret).to include 'away_goals'
      end
    end

    context 'game_goalies' do
      ret = s.game_goalies(128740, only: :away)

      it 'returns a list of away goalies' do
        expect(ret).to include 'away_goalies'
      end
    end

    context 'game_penalties' do
      ret = s.game_penalties(128740, only: :away)

      it 'returns a list of away penalties' do
        expect(ret).to include 'away_penalties'
      end
    end

    context 'game_roster' do
      ret = s.game_roster(128740, only: :away)

      it 'returns an away roster' do
        expect(ret).to include 'away_roster'
      end
    end

    context 'division_standings' do
      ret = s.division_standings(3057, type: 'Regular Season')

      it 'returns ranked list of teams' do
        expect(ret).to include 'teams'
      end
    end

    context 'division_teams' do
      ret = s.division_teams(3057)

      it 'returns a list of teams' do
        expect(ret).to include 'teams'
      end
    end

    context 'division_leaders' do
      ret = s.division_leaders(3057, type: 'Regular Season', limit: 5, metrics: [:points, :goals, :assists])

      it 'returns a list of leaders' do
        expect(ret).to include 'leaders'
      end
    end

    context 'division_suspensions' do
      ret = s.division_suspensions(3057, only_active: false)

      it 'returns a list of suspensions' do
        expect(ret).to include 'suspensions'
      end
    end
  end
end

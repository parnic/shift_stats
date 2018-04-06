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
      it 'returns something' do
        expect(team_search).to be_truthy
      end

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

      it 'returns something' do
        expect(team_schedule).to be_truthy
      end
    end

    context 'team_players_list' do
      team_players = s.team_players_list(18827)

      it 'returns something' do
        expect(team_players).to be_truthy
      end
    end

    context 'division_games_list' do
      division_games = s.division_games_list(3057)

      it 'returns something' do
        expect(division_games).to be_truthy
      end
    end

    context 'season_divisions_list' do
      season_divisions = s.season_divisions_list(741)

      it 'returns something' do
        expect(season_divisions).to be_truthy
      end
    end
  end
end

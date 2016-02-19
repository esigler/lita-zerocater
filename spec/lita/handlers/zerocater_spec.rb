require 'spec_helper'

describe Lita::Handlers::Zerocater, lita_handler: true do
  before do
    registry.config.handlers.zerocater.locations = { 'foo' => 'bar' }
  end

  it { is_expected.to route_command('zerocater today').to(:today) }
  it { is_expected.to route_command('zerocater tomorrow').to(:tomorrow) }
  it { is_expected.to route_command('zerocater yesterday').to(:yesterday) }
  it { is_expected.to route_command('lunch').to(:today) }
  it { is_expected.to route_command('Lunch').to(:today) }

  let(:menu) do
    File.read('spec/files/meals.json')
  end

  describe '#today' do
    it 'shows the menu for today' do
      Timecop.travel(Time.local(2016, 2, 23, 8, 0, 0))
      grab_request('get', 200, menu)
      send_command('zerocater today')
      expect(replies.last).to eq(<<-MENU
Menu for foo:

Week of Stuphin: Ike's Feast
MENU
                                )
    end

    it 'shows nothing if there are no menu items' do
      Timecop.travel(Time.local(2016, 1, 1, 8, 0, 0))
      grab_request('get', 200, menu)
      send_command('zerocater today')
      expect(replies.last).to eq('There are no menu items found for today')
    end

    it 'shows a warning if there was a problem retriving the page' do
      allow_any_instance_of(Faraday::Connection).to receive('get').and_raise
      send_command('zerocater today')
      expect(replies.last).to eq('There was an error retriving the menu')
    end
  end

  describe '#tomorrow' do
    it 'shows the menu for tomorrow' do
      Timecop.travel(Time.local(2016, 2, 23, 8, 0, 0))
      grab_request('get', 200, menu)
      send_command('zerocater tomorrow')
      expect(replies.last).to eq(<<-MENU
Menu for foo:

Week of Stuphin: On-Site Crepes!
Week of Stupin: On-Site Belly Burgers!
MENU
                                )
    end
  end

  describe '#yesterday' do
    it 'shows the menu for yesterday' do
      Timecop.travel(Time.local(2016, 2, 23, 8, 0, 0))
      grab_request('get', 200, menu)
      send_command('zerocater yesterday')
      expect(replies.last).to eq("Menu for foo:\n\nWeek of Stuphin: Limon\n")
    end
  end
end

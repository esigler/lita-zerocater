require 'spec_helper'

describe Lita::Handlers::Zerocater, lita_handler: true do
  before do
    registry.config.handlers.zerocater.locations = { 'foo' => 'YVKV' }
  end

  it { is_expected.to route_command('zerocater today').to(:menu) }
  it { is_expected.to route_command('zerocater tomorrow').to(:menu) }
  it { is_expected.to route_command('zerocater yesterday').to(:menu) }
  it { is_expected.to route_command('breakfast').to(:alias) }
  it { is_expected.to route_command('brunch').to(:alias) }
  it { is_expected.to route_command('lunch').to(:alias) }
  it { is_expected.to route_command('Lunch').to(:alias) }
  it { is_expected.to route_command('dinner').to(:alias) }

  describe '#menu' do
    it 'shows the menu for today' do
      Timecop.travel(Time.local(2016, 4, 5, 8, 0, 0))
      VCR.use_cassette('zerocater') do
        send_command('zerocater today')
        expect(replies.last).to eq(<<-MENU
Menu for foo:

Korean-Thai Fusion (Crazy Mint)
Seasonal Salad Bar: Springtime (Seasonal Salad Bar By 2Forks)
MENU
                                  )
      end
    end

    it 'shows nothing if there are no menu items' do
      Timecop.travel(Time.local(2016, 1, 1, 8, 0, 0))
      VCR.use_cassette('zerocater') do
        send_command('zerocater today')
        expect(replies.last).to eq('There are no menu items found for today')
      end
    end

    it 'shows a warning if there was a problem retriving the page' do
      allow_any_instance_of(Faraday::Connection).to receive('get').and_raise
      send_command('zerocater today')
      expect(replies.last).to eq('There was an error retriving the menu')
    end
  end

  it 'shows the menu for tomorrow' do
    Timecop.travel(Time.local(2016, 4, 5, 8, 0, 0))
    VCR.use_cassette('zerocater') do
      send_command('zerocater tomorrow')
      expect(replies.last).to eq(<<-MENU
Menu for foo:

French Breakfast Crepes! (Crepe Madame)
Sandwiches! (Green Bar)
Seasonal Salad Bar: Springtime (Seasonal Salad Bar By 2Forks)
MENU
                                )
    end
  end

  it 'shows the menu for yesterday' do
    Timecop.travel(Time.local(2016, 4, 5, 8, 0, 0))
    VCR.use_cassette('zerocater') do
      send_command('zerocater yesterday')
      expect(replies.last).to eq(<<-MENU
Menu for foo:

Seasonal Salad Bar: Springtime (Seasonal Salad Bar By 2Forks)
Chicken & Meatballs (Cafe Sud)
MENU
                                )
    end
  end

  describe '#alias' do
    it 'shows the menu for today' do
      Timecop.travel(Time.local(2016, 4, 5, 8, 0, 0))
      VCR.use_cassette('zerocater') do
        send_command('lunch')
        expect(replies.last).to eq(<<-MENU
Menu for foo:

Korean-Thai Fusion (Crazy Mint)
Seasonal Salad Bar: Springtime (Seasonal Salad Bar By 2Forks)
MENU
                                  )
      end
    end
  end
end

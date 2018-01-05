# frozen_string_literal: true

require 'spec_helper'

describe Lita::Handlers::Zerocater, lita_handler: true do
  before do
    registry.config.handlers.zerocater.locations = { 'foo' => 'YVKV' }
  end

  let(:menu_yesterday) do
    <<~MENU
      Menu for foo:

      *Seasonal Salad Bar: Springtime* (Seasonal Salad Bar By 2Forks)
      -    Springtime Salad Bar | 🌱
      -    Grilled Chicken Breast
      -    Grilled Tofu | 🌱
      -    Avocado | 🌱
      -    Citrus Vinaigrette | 🌱
      -    Balsamic Vinaigrette | 🌱
      -    Romano Cheese | 🥕 🧀
      -    Almond Slivers | 🌱 🥜
      -    Citrus Avocado Dressing
      -    Dried Cherries | 🌱
      *Chicken & Meatballs* (Cafe Sud)
      -    Turkey Meatballs with Fresh Tomato Sauce | 🍞 🥚
      -    Sundried Tomato Grilled Chicken
      -    Pesto Aioli | 🥕 🥚
      -    French Organic Lentils | 🌱
      -    Garlic and Rosemary Roasted Potatoes | 🌱
      -    Grilled Vegetables | 🌱
      -    French Organic Lentils | 🌱
MENU
  end

  let(:menu_today) do
    <<~MENU
      Menu for foo:

      *Korean-Thai Fusion* (Crazy Mint)
      -    Sweet Garlic Ginger Grilled Chicken | 🍞
      -    Spicy Korean BBQ Chicken | 🍞
      -    Tofu Green Curry | 🌱
      -    Coconut Rice | 🌱
      -    Soba Noodle Salad | 🍞 🌱
      -    Sake and Miso Glazed Japanese Eggplants | 🌱
      -    Vegetable and Bean Cake | 🌱
      *Seasonal Salad Bar: Springtime* (Seasonal Salad Bar By 2Forks)
      -    Springtime Salad Bar | 🌱
      -    Grilled Chicken Breast
      -    Grilled Tofu | 🌱
      -    Avocado | 🌱
      -    Citrus Vinaigrette | 🌱
      -    Balsamic Vinaigrette | 🌱
      -    Citrus Avocado Dressing
      -    Almond Slivers | 🌱 🥜
      -    Romano Cheese | 🧀 🥕
MENU
  end

  let(:menu_tomorrow) do
    <<~MENU
      Menu for foo:

      *French Breakfast Crepes!* (Crepe Madame)
      -    Savory Buckwheat Crepes | 🧀 🥕 🥚
      -    Sweet Crepes | 🧀 🍞 🥕 🥚 🥜
      -    Organic Egg | 🥕 🥚
      *Sandwiches!* (Green Bar)
      -    BBQ Chicken with Smoked Gouda Sandwich | 🧀 🍞
      -    Gluten-Free BBQ Chicken with Smoked Gouda Sandwich | 🧀
      -    Beef Tri-Tip Sandwich | 🧀 🍞 🥚
      -    Ham and Brie Sandwich | 🥓 🧀 🍞
      -    Roast Turkey Sandwich with Cranberry Sauce | 🍞 🥚
      -    Gluten-Free Roast Turkey Sandwich with Cranberry Sauce | 🥚
      -    Gluten-Free Grilled Chicken Sandwich | 🥚
      -    Grilled Chicken Sandwich | 🍞 🥚
      -    Hummus, Cucumber, Avocado, and Tomato on Focaccia | 🌱 🍞
      -    Grilled Portobello Mushroom with Provolone Sandwich | 🥕 🧀 🍞
      -    Creamy Brie with Sun Dried Tomato Pesto, Sprouts, and Sliced Apple | 🥕 🥜 🧀 🍞
      -    Grilled Portobello Mushroom with Provolone Sandwich | 🥕 🧀 🍞
      -    Kale Salad | 🌱
      *Seasonal Salad Bar: Springtime* (Seasonal Salad Bar By 2Forks)
      -    Springtime Salad Bar | 🌱
      -    Grilled Chicken Breast
      -    Grilled Tofu | 🌱
      -    Avocado | 🌱
      -    Citrus Vinaigrette | 🌱
      -    Balsamic Vinaigrette | 🌱
      -    Romano Cheese | 🥕 🧀
      -    Almond Slivers | 🌱 🥜
MENU
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
        expect(replies.last).to eq(menu_today)
      end
    end

    it 'shows nothing if there are no menu items' do
      Timecop.travel(Time.local(2016, 1, 1, 8, 0, 0))
      VCR.use_cassette('zerocater') do
        send_command('zerocater today')
        expect(replies.last).to eq('There are no menu items found for today')
      end
    end

    # rubocop:disable RSpec/AnyInstance
    it 'shows a warning if there was a problem retrieving the page' do
      allow_any_instance_of(Faraday::Connection).to receive('get').and_raise
      send_command('zerocater today')
      expect(replies.last).to eq('There was an error retrieving the menu')
    end
    # rubocop:enable RSpec/AnyInstance
  end

  it 'shows the menu for tomorrow' do
    Timecop.travel(Time.local(2016, 4, 5, 8, 0, 0))
    VCR.use_cassette('zerocater') do
      send_command('zerocater tomorrow')
      expect(replies.last).to eq(menu_tomorrow)
    end
  end

  it 'shows the menu for yesterday' do
    Timecop.travel(Time.local(2016, 4, 5, 8, 0, 0))
    VCR.use_cassette('zerocater') do
      send_command('zerocater yesterday')
      expect(replies.last).to eq(menu_yesterday)
    end
  end

  describe '#alias' do
    it 'shows the menu for today' do
      Timecop.travel(Time.local(2016, 4, 5, 8, 0, 0))
      VCR.use_cassette('zerocater') do
        send_command('lunch')
        expect(replies.last).to eq(menu_today)
      end
    end
  end
end

module Lita
  module Handlers
    class Zerocater < Handler
      config :locations, type: Hash, required: true

      route(
        /^zerocater\stoday$/,
        :today,
        command: true,
        help: {
          t('help.today.syntax') => t('help.today.desc')
        }
      )

      route(
        /^zerocater\stomorrow$/,
        :tomorrow,
        command: true,
        help: {
          t('help.tomorrow.syntax') => t('help.tomorrow.desc')
        }
      )

      route(
        /^zerocater\syesterday$/,
        :yesterday,
        command: true,
        help: {
          t('help.yesterday.syntax') => t('help.yesterday.desc')
        }
      )

      route(
        /^(breakfast|brunch|lunch|dinner)$/i,
        :today,
        command: true,
        help: {
          t('help.lunch.syntax') => t('help.lunch.desc')
        }
      )

      def today(response)
        config.locations.keys.each do |location|
          response.reply(menu_today(location))
        end
      end

      def tomorrow(response)
        config.locations.keys.each do |location|
          response.reply(menu_tomorrow(location))
        end
      end

      def yesterday(response)
        config.locations.keys.each do |location|
          response.reply(menu_yesterday(location))
        end
      end

      private

      def fetch_meals(location)
        JSON.parse(
          http.get("https://api.zerocater.com/v3/companies/#{location}/meals")
          .body
        )
      end

      def fetch_meal(id)
        JSON.parse(http.get("https://api.zerocater.com/v3/meals/#{id}").body)
      end

      def find_meals(meals, search_date)
        results = []
        meals.each do |item|
          date = DateTime.strptime(item['time'].to_s, '%s').strftime('%Y-%m-%d')
          results << item['id'] if date == search_date
        end
        results
      end

      def find_menu(location, search_date)
        results = find_meals(fetch_meals(location), search_date)
        meals = []

        results.each do |result|
          m = fetch_meal(result)
          meals << m['name']
        end

        meals
      end

      def render_menu(location, search_date)
        menu = find_menu(config.locations[location], search_date)
        return t('error.empty') if menu.empty?

        render_template('menu',
                        menu: menu,
                        locale: t('menu.locale', location: location))
      rescue
        t('error.retrieve')
      end

      def menu(location, search_date)
        cache_key = "#{location}_#{search_date}"
        return redis.get(cache_key) if redis.exists(cache_key)
        menu = render_menu(location, search_date)
        redis.set(cache_key, menu)
        menu
      end

      def menu_today(location)
        menu(location, Date.today.to_s)
      end

      def menu_yesterday(location)
        menu(location, (Date.today - 1).to_s)
      end

      def menu_tomorrow(location)
        menu(location, (Date.today + 1).to_s)
      end
    end

    Lita.register_handler(Zerocater)
  end
end

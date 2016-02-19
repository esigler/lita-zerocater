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
        /^lunch$/,
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

      def fetch(location)
        http.get("https://api.zerocater.com/v3/companies/#{location}/meals")
      end

      def extract(menu_text, search_date)
        results = []
        content = JSON.parse(menu_text.body)
        content.each do |item|
          date = DateTime.strptime(item['time'].to_s, '%s').strftime('%Y-%m-%d')
          results << item['name'] if date == search_date
        end
        results
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def menu(location, search_date)
        cache_key = "#{location}_#{search_date}"
        return redis.get(cache_key) if redis.exists(cache_key)

        menu = extract(fetch(config.locations[location]), search_date)
        return t('error.empty') if menu.empty?

        t = render_template('menu',
                            menu: menu,
                            locale: t('menu.locale', location: location))

        redis.set(cache_key, t)
        t
      rescue
        t('error.retrieve')
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

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

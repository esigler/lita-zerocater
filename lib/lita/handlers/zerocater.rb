module Lita
  module Handlers
    class Zerocater < Handler
      config :locations, type: Hash, required: true

      route(
        /^zerocater\s(?<date>today|tomorrow|yesterday)$/,
        :menu,
        command: true,
        help: {
          t('help.menu.syntax') => t('help.menu.desc')
        }
      )

      route(
        /^(breakfast|brunch|lunch|dinner)$/i,
        :alias,
        command: true,
        help: {
          t('help.alias.syntax') => t('help.alias.desc')
        }
      )

      # rubocop:disable Metrics/MethodLength
      def menu(response)
        search_date = case response.match_data['date']
                      when 'tomorrow'
                        Date.today + 1
                      when 'yesterday'
                        Date.today - 1
                      else
                        Date.today
                      end
        config.locations.keys.each do |location|
          response.reply(fetch_menu(location, search_date))
        end
      end
      # rubocop:enable Metrics/MethodLength

      def alias(response)
        config.locations.keys.each do |location|
          response.reply(fetch_menu(location, Date.today))
        end
      end

      private

      def fetch_meal(id)
        JSON.parse(http.get("https://api.zerocater.com/v3/meals/#{id}").body)
      end

      def fetch_meals(location)
        JSON.parse(
          http.get("https://api.zerocater.com/v3/companies/#{location}/meals")
          .body
        )
      end

      def fetch_menu(location, search_date)
        # cache_key = "#{location}_#{search_date}"
        # return redis.get(cache_key) if redis.exists(cache_key)

        menu = render_menu(location, search_date)
        # redis.set(cache_key, menu)

        menu
      end

      def find_meals(meals, search_date)
        results = []

        meals.each do |item|
          results << item['id'] if Time.at(item['time']).to_date == search_date
        end

        results
      end

      def find_menu(location, search_date)
        results = find_meals(fetch_meals(location), search_date)
        meals = []

        results.each do |result|
          m = fetch_meal(result)
          meals << m
        end

        meals
      end
      
      # append emoji icons based on item labels
      def append_icons(item)
          name = item['name']
          icons = {
            "nuts" => "🥜",
            "vegan" => "🌱",
            "dairy" => "🧀",
            "egg" => "🥚",
            "vegetarian" => "🥕",
            "gluten" => "🍞",
            "shellfish" => "🦐",
            "red meat" => "🍖",
            "pork" => "🥓"
          }
          labels = item['labels'].select { |label, value| value['value'] == true && icons.key?(label) }
              .map { |label, v| icons[label] }
          # if it's vegan, it's necessarily vegetarian. Remove redundant icon.
          if labels.include?(icons['vegetarian']) && labels.include?(icons['vegan'])
              labels.delete_at(labels.index(icons['vegetarian']))
          end
          name = labels.empty? ? name : name << " | " << labels.join(" ")
          name
      end

      def render_menu(location, search_date)
        menu = find_menu(config.locations[location], search_date)
        return t('error.empty') if menu.empty?
     
        items = menu.map { |m| m['items'].map{ |item| append_icons(item) } }
        render_template('menu',
                      menu: menu,
                      items: items,
                      locale: t('menu.locale', location: location))
      end
    end

    Lita.register_handler(Zerocater)
  end
end

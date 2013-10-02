require 'rufus-scheduler'

class PriceWorker

  def schedule
    scheduler = Rufus::Scheduler.start_new

    scheduler.every("6h") do
      PriceWorker.new.perform
    end
  end

  def perform
    puts 'START updating prices'
      users = User.all

      for user in users
        for list in user.lists
          for item in list.items
            ItemParser.update_price item
          end
        end
      end

    ActiveRecord::Base.clear_active_connections!
    puts 'STOP updating prices'
  end
end


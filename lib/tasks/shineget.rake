class SyncWorker
  def perform
    puts 'START syncing lists'
      users = User.all

      for user in users
        for list in user.lists
          ListParser.update_list list if list.is_external?
        end
      end

    ActiveRecord::Base.clear_active_connections!
    puts 'STOP syncing lists'
  end

end

class PriceWorker

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


namespace :shineget do
  desc "tasks to manage wishlists and price comparisons"

  task :sync => :environment do
    SyncWorker.new.perform
  end

  task :price => :environment do
    PriceWorker.new.perform
  end
end

require 'rufus-scheduler'

class SyncWorker

  def schedule
    scheduler = Rufus::Scheduler.start_new

    scheduler.every("6h") do
      SyncWorker.new.perform
    end
  end

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


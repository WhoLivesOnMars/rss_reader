# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
set :output, "/home/daria/projects/rss_reader_api/log/cron.log"
set :environment, "development"

every 30.minutes do
   command "/home/daria/projects/rss_reader_api/script/fetch_feeds.sh"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

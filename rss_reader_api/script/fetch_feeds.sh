set -euo pipefail

APP_PATH="/home/daria/projects/rss_reader_api"
LOG_DIR="$APP_PATH/log"
PROBE_FILE="$LOG_DIR/cron_probe.txt"

export PATH="/home/daria/.local/share/mise/installs/ruby/3.4.7/bin:/usr/local/bin:/usr/bin:/bin"
export RAILS_ENV=development
export BUNDLE_GEMFILE="$APP_PATH/Gemfile"

cd "$APP_PATH"

/home/daria/.local/share/mise/installs/ruby/3.4.7/bin/bundle exec bin/rails runner 'FetchFeedsJob.perform_now'

echo "$(date '+%Y-%m-%d %H:%M:%S') ✅ job via bundle OK" >> "$PROBE_FILE"

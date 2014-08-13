web: bundle exec rackup config.ru -p $PORT
worker: bundle exec sidekiq -r ./builda.rb -c 5 -v

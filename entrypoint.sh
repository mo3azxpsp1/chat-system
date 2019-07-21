#!/bin/bash

# if RAILS_ENV was NOT set before then default to development
[[ -z "$RAILS_ENV" ]] && export RAILS_ENV=development

# Symlink the log file to stdout for Docker
echo "⚰  Symlinking to /app/log/$RAILS_ENV.log"
ln -sf /dev/stdout /app/log/$RAILS_ENV.log

if [ -e ".env" ]; then
  # Load any local ENV vars
  echo "⚰  Loading local environment variables..."
  source .env
fi

echo "🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖 $RAILS_ENV 🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖🤖"

if [ "$RAILS_ENV" = 'development' ]; then

  bundle install # if gems are volume persistant, you can run it safely with every boot
  rake db:create db:migrate
  rake db:seed
  bundle exec puma -p ${PORT:-3000} -e ${RAILS_ENV:-development} -w ${WEB_CONCURRENCY:-1} -t ${RAILS_MAX_THREADS:-1}:${RAILS_MAX_THREADS:-1}

fi

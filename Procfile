web: exec bin/rails s -b 0.0.0.0 -p ${PORT:-3000}
release: exec bin/rails db:migrate RAILS_ENV=${RAILS_ENV:-development}
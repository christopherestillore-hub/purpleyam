#!/usr/bin/env bash
set -euo pipefail

cd /var/www/html

if [[ ! -f vendor/autoload.php ]]; then
  composer install --no-interaction --prefer-dist --optimize-autoloader
fi

if [[ ! -f .env && -f .env.example ]]; then
  cp .env.example .env
fi

if [[ -f .env ]] && ! grep -Eq '^APP_KEY=base64:.+' .env; then
  php artisan key:generate --force 2>/dev/null || true
fi

exec php artisan serve --host=0.0.0.0 --port=8080

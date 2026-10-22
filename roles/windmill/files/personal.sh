# Runs once, when the Postgres volume is first initialised.
# Personal data lives in its own database, apart from Windmill's internal one.
psql -v ON_ERROR_STOP=1 -v password="$PERSONAL_PASSWORD" --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<'SQL'
CREATE ROLE personal LOGIN PASSWORD :'password';
CREATE DATABASE personal OWNER personal;
SQL

# OC — OpenCaching Development Environment

One command starts the entire opencaching stack: legacy PHP app (OC3),
Symfony frontend (OC4), shared MariaDB, and Traefik reverse proxy.

## Quick Start

    git clone git@github.com:hxdimpf/OC.git
    git clone git@github.com:hxdimpf/OC3.git ../oc3
    git clone git@github.com:hxdimpf/OC4.git ../oc4
    cd OC
    cp .env.dist .env
    docker compose up -d

- **OC3** (legacy): http://oc3.localhost
- **OC4** (Symfony): http://oc4.localhost

## Architecture

    traefik :80
       ├── oc3.localhost  →  OC3 (php:8.2, /htdocs)
       └── oc4.localhost  →  OC4 (php:8.4, /public)
               │
               └── db (mariadb:10.11)

Source repos are mounted as volumes — edit locally, reload in browser.

## Database

The shared MariaDB initializes from `db/init/`. Drop your schema dump
(`dump_v158.sql.gz`) there before first start, or import manually:

    docker compose exec -T db mysql -uoc -poc oc < dump.sql

# CLAUDE.md — OC Docker Stack

## Where to work: ALWAYS on your Mac in ~/src/

**Never edit files on the server** (`ssh baiti@oc3.baiti.net`). The server is deployment target only.
All editing, committing, and pushing happens from your Mac.

### Repos and local paths

| Repo | Local path | What it contains |
|------|-----------|-----------------|
| `hxdimpf/OC` | `~/src/oc` | Playbook, scripts, docs |
| `hxdimpf/OC3` | `~/src/oc3` | Legacy PHP app |
| `hxdimpf/OC4` | `~/src/oc4` | Symfony 7.x frontend |
| `hxdimpf/oc5` | `~/src/oc5` | Node.js/Express frontend |
| `hxdimpf/okapi` | `~/src/okapi` | OKAPI REST API |
| `hxdimpf/oc-frontend` | `~/src/oc5/public/_frontend/` | Shared JS/CSS/vendor (git submodule) |

### Workflow

**For backend code (PHP, Node.js, templates):**
```
1. cd ~/src/oc5                    # edit locally
2. git add -A && git commit -m "..." && git push origin dev-hx
3. ssh oc3 "sudo git -C /opt/repos/oc5 pull && sudo docker restart oc5-oc5-1"
```

**For shared frontend JS/CSS (`oc-frontend` submodule):**
```
1. cd ~/src/oc5/public/_frontend   # edit submodule locally
2. git add -A && git commit -m "..." && git push origin dev-hx
3. cd ~/src/oc5 && git submodule update --remote public/_frontend && git commit -am "fix: update submodule" && git push origin dev-hx
4. cd ~/src/oc4 && git pull origin dev-hx && git submodule update --remote public/_frontend && git commit -am "fix: update submodule" && git push origin dev-hx
5. ssh oc3 "sudo git -C /opt/repos/oc5 pull && sudo git -C /opt/repos/oc5 submodule update --init && sudo git -C /opt/repos/oc4 pull && sudo git -C /opt/repos/oc4 submodule update --init && sudo docker restart oc4-oc4-1 oc5-oc5-1"
```

**For Ansible playbook changes:**
```
1. cd ~/src/oc/ansible            # edit playbook or config
2. git add -A && git commit -m "..." && git push origin dev-hx
3. ansible-playbook -i inventory.ini deploy.yml -e "db_dump_file=..."
```

**Never:** edit on the server, commit on the server, push from the server.
**Always:** edit locally → commit → push → deploy via SSH pull + restart.

## Critical Rules (read first, never skip)

### 1. Templates: OC4 Twigs are canonical, OC5 Nunjucks are derived

OC4 and OC5 share the `oc-frontend` git submodule. Templates must produce IDENTICAL DOM.

**All template changes MUST be made in OC4's Twig files first.**
OC5 Nunjucks files are derived artifacts — never edit them directly.

The ONLY safe way to create an OC5 template from an OC4 template:

```bash
./scripts/convert-twig.sh <oc4-template.twig> <oc5-output.njk>
```

This script handles: `extends`, `parent()`→`super()`, `|trans`→i18n lookup, `|json_encode|raw`→`|safe`.
It does NOT handle `path()` routes, `app.request.locale`, `knp_menu_render`, `"now"|date` — those must be inspected manually.

**Exception: `base.njk` is hand-maintained.** The OC4 Twig `base.html.twig` uses many Symfony-specific
constructs (`app.request.locale`, `path()`, `knp_menu_render()`, `|date("Y")`) that the converter
cannot handle. The OC5 `base.njk` is maintained manually. When the OC4 base template changes,
apply the same change manually to OC5's `base.njk` — do NOT run the converter on it.

**Never write a template from scratch.** Always start from the OC4 Twig original.

### 2. Nunjucks compatibility filters are in app.js

OC5's `app.js` adds Twig-compatible filters:
- `|format('%.1f', value)` — printf-style
- `|number_format(decimals, dec_sep, thou_sep)` — like Twig's number_format
- `range(start, end)` — global function

If a converted template fails with "filter not found", add the filter to `app.js`,
NOT to the template.

### 3. After every deploy, run tests

```bash
./scripts/test-deploy.sh all
```

This checks every page, every asset path, every image directory, and API endpoints.
Zero failures required before declaring "done".

### 4. Image paths

Images live in `public/images/` and are served at `/images/` on both OC4 and OC5.
OC5 also serves `/_frontend/images/` as a fallback for legacy paths.
OC4 has symlinks: `_frontend/css`→`_frontend/public/css`, same for js/vendor.
OC4 also has root-level symlinks: `public/css`→`public/_frontend/public/css`, etc.

### 5. The playbook is the source of truth

`ansible/deploy.yml` must produce a working system with no manual fixes.
Every runtime fix must be backported to the playbook.

Deploy command:
```bash
cd ansible
ansible-playbook -i inventory.ini deploy.yml \
  -e "db_dump_file=/path/to/dump.sql.gz" \
  -e "git_user_name=hxdimpf" \
  -e "git_user_email=hxdimpf@gmail.com"
```

## Repos

| Repo | Purpose | Branch |
|------|---------|--------|
| `hxdimpf/OC` | Ansible playbook, deploy scripts | `dev-hx` |
| `hxdimpf/OC3` | Legacy PHP (Symfony 3.x) | `dev-hx` |
| `hxdimpf/OC4` | Symfony 7.x frontend | `dev-hx` |
| `hxdimpf/oc5` | Node.js/Express frontend | `dev-hx` |
| `hxdimpf/okapi` | OKAPI REST API | `dev-hx` |

Local paths: `/Users/baiti/src/oc/`, `/Users/baiti/src/oc3/`, `/Users/baiti/src/oc4/`, `/Users/baiti/src/oc5/`, `/Users/baiti/src/okapi/`

## Infrastructure

Test server: `oc3.baiti.net` (192.168.192.11), SSH user `baiti`.
Docker on test server requires `sudo`.
Stacks at `/opt/stacks/`, repos at `/opt/repos/`.

NPM (Nginx Proxy Manager) routes by Host header:
- oc3.baiti.net → oc3:80
- oc4.baiti.net → oc4:80
- oc5.baiti.net → oc5:3000
- okapi.baiti.net → okapi:80

NPM config lives in SQLite: `/var/lib/docker/volumes/npm_npm_data/_data/database.sqlite`
Regenerate with: `echo y | docker exec -i npm-nginx-proxy-manager-1 node scripts/regenerate-config`

## Session Management

**Three independent stacks, three independent sessions.**

| Stack | Cookie name | Domain |
|-------|------------|--------|
| OC3 | `ocdevelopmentdata` | none (host-only) |
| OC4 | `oc4_session` | none (host-only) |
| OC5 | `oc5_session` | none (host-only) |

All three validate against `sys_sessions` in the shared MariaDB.
No cross-subdomain cookie sharing. Each stack requires its own login.

**Why:** Chrome blocks cross-subdomain cookies on private IPs (192.168.x.x).
Even with `.baiti.net` domain cookies, the browser refuses to send them.
Independent host-only cookies are the only reliable approach for dev.

Cookie domain is EMPTY STRING in all settings:
- OC3: `$opt['session']['domain'] = '';` in playbook-generated `settings.inc.php`
- OC4: `null` domain in `Auth.php` Cookie constructor
- OC5: no domain parameter in `res.cookie()` call

For production on public DNS with real certificates, cross-subdomain cookies
can be re-enabled by setting domain to `.baiti.net`.

## oc5 specifics

- Express 5, ES modules (`"type": "module"`)
- Nunjucks templates at `public/templates/nunjucks/`
- Shared frontend submodule at `public/_frontend/` (from `hxdimpf/oc-frontend`)
- `app.js` has `format`, `number_format` filters and `range()` global
- No helmet (dev env)
- Auth: `oc5_session` cookie → `sys_sessions` validation via `src/auth.js`
- DB: MariaDB via `mariadb` npm package, connection pool in `src/db.js`

## SSL (dev only)

Self-signed wildcard cert for `*.baiti.net` generated by playbook.
NPM's cert management is buggy with self-signed certs — config may need manual
`http_top.conf` with SSL server block. See deploy.yml NPM section for pattern.

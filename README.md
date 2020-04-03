# ansible-role-mongodb

Manage `mongodb`. It does not support replication and sharding.

## Notes for all users

The role runs `flush_handlers` during the play.

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `mongodb_user` | user name of `mongodb` | `{{ __mongodb_user }}` |
| `mongodb_group` | group name of `mongodb` | `{{ __mongodb_group }}` |
| `mongodb_package` | package name of `mongodb` | `{{ __mongodb_package }}` |
| `mongodb_extra_packages` | a list of extra packages to install | `[]` |
| `mongodb_log_dir` | path to log directory  | `{{ __mongodb_log_dir }}` |
| `mongodb_log_file` | path to `mongod.log` | `{{ mongodb_log_dir }}/mongod.log` |
| `mongodb_db_dir` | path to database directory | `{{ __mongodb_db_dir }}` |
| `mongodb_service` | service name of `mongodb` | `{{ __mongodb_service }}` |
| `mongodb_conf_dir` | path to configuration directory | `{{ __mongodb_conf_dir }}` |
| `mongodb_conf_file` | path to `mongod.conf` | `{{ mongodb_conf_dir }}/mongodb.conf` |
| `mongodb_flags` | TBW | `""` |
| `mongodb_debug` | if true, disable `no_log` in the role | `no` |
| `mongodb_port` | listening port | `27017` |
| `mongodb_host` | listening address | `127.0.0.1` |
| `mongodb_users` | see below | `[]` |
| `mongodb_admin_users` | see below | `[]` |
| `mongodb_config` | content of `mongod.conf` | `""` |
| `mongodb_config_init_auth` | content of `mongod.conf` used only when authentication is initialized | `""` |

## `mongodb_users`

This is a list of dict. Each element is passed to
[`mongodb_user`](https://docs.ansible.com/ansible/latest/modules/mongodb_user_module.html#mongodb-user-module)
`ansible` module.

## `mongodb_admin_users`

Same as `mongodb_users` but admin user. The first user is used when creating
`mongodb_users` as `login_user`.

## Debian

| Variable | Default |
|----------|---------|
| `__mongodb_user` | `mongodb` |
| `__mongodb_group` | `mongodb` |
| `__mongodb_package` | `mongodb` |
| `__mongodb_log_dir` | `/var/log/mongodb` |
| `__mongodb_db_dir` | `/var/lib/mongodb` |
| `__mongodb_service` | `mongodb` |
| `__mongodb_conf_dir` | `/etc` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__mongodb_user` | `mongodb` |
| `__mongodb_group` | `mongodb` |
| `__mongodb_package` | `databases/mongodb40` |
| `__mongodb_log_dir` | `/var/log/mongodb` |
| `__mongodb_db_dir` | `/var/db/mongodb` |
| `__mongodb_service` | `mongod` |
| `__mongodb_conf_dir` | `/usr/local/etc` |

# Dependencies

None

# Example Playbook

```yaml
```

# License

```
Copyright (c) 2020 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>

This README was created by [qansible](https://github.com/trombik/qansible)

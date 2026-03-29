set shell := ["bash", "-euo", "pipefail", "-c"]

ssh_target := "personal"
app_name := "todoorganized"
remote_app_dir := "/srv/todoorganized"
release_archive_name := "todoorganized.tar.gz"
service_name := "todoorganized"
service_file := "deploy/todoorganized.service"
env_file := "production-secret.env"
production_databases := "to_do_organized_production to_do_organized_production_cache to_do_organized_production_queue to_do_organized_production_cable"

default:
    @just --list

pack-release:
    rm -f {{release_archive_name}}
    tmp_archive="$$(mktemp /tmp/{{app_name}}.XXXXXX.tar.gz)"; \
    trap 'rm -f "$$tmp_archive"' EXIT; \
    git ls-files --cached --others --exclude-standard -z | \
        tar --null -czf "$$tmp_archive" --files-from -; \
    mv "$$tmp_archive" {{release_archive_name}}; \
    trap - EXIT

upload-release: pack-release
    scp {{release_archive_name}} {{ssh_target}}:/tmp/{{release_archive_name}}

upload-env:
    test -f {{env_file}}
    scp {{env_file}} {{ssh_target}}:/tmp/{{env_file}}

install-service:
    scp {{service_file}} {{ssh_target}}:/tmp/{{service_name}}.service
    ssh {{ssh_target}} "sudo install -d -m 755 {{remote_app_dir}}"
    ssh {{ssh_target}} "sudo install -m 644 /tmp/{{service_name}}.service /etc/systemd/system/{{service_name}}.service"
    ssh {{ssh_target}} "rm -f /tmp/{{service_name}}.service"
    ssh {{ssh_target}} "sudo systemctl daemon-reload"
    ssh {{ssh_target}} "sudo systemctl enable {{service_name}}"

    printf 'Installed service %s on %s\n' "{{service_name}}" "{{ssh_target}}"

deploy: upload-release upload-env
    ssh {{ssh_target}} "sudo install -d -m 755 {{remote_app_dir}}"
    ssh {{ssh_target}} "sudo find {{remote_app_dir}} -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +"
    ssh {{ssh_target}} "sudo tar -xzf /tmp/{{release_archive_name}} -C {{remote_app_dir}}"
    ssh {{ssh_target}} "sudo install -m 600 /tmp/{{env_file}} {{remote_app_dir}}/{{env_file}}"
    ssh {{ssh_target}} "rm -f /tmp/{{release_archive_name}} /tmp/{{env_file}}"
    ssh {{ssh_target}} "cd {{remote_app_dir}} && sudo docker compose up -d db"
    ssh {{ssh_target}} "cd {{remote_app_dir}} && until sudo docker compose exec -T db pg_isready -U to_do_organized -d postgres >/dev/null 2>&1; do sleep 1; done"
    ssh {{ssh_target}} "cd {{remote_app_dir}} && for db in {{production_databases}}; do sudo docker compose exec -T db psql -U to_do_organized -d postgres -tAc \"SELECT 1 FROM pg_database WHERE datname='$$db'\" | grep -q 1 || sudo docker compose exec -T db psql -U to_do_organized -d postgres -c \"CREATE DATABASE \\\"$$db\\\"\"; done"
    ssh {{ssh_target}} "cd {{remote_app_dir}} && sudo docker compose run --rm --build web ./bin/rails db:prepare"
    ssh {{ssh_target}} "cd {{remote_app_dir}} && sudo docker compose up -d --build --remove-orphans"

    rm -f {{release_archive_name}}
    printf 'Deployed app to %s:%s\n' "{{ssh_target}}" "{{remote_app_dir}}"

bootstrap: install-service deploy
    ssh {{ssh_target}} "sudo systemctl start {{service_name}}"

status:
    ssh {{ssh_target}} "sudo systemctl --no-pager --full status {{service_name}}"

logs:
    ssh {{ssh_target}} "cd {{remote_app_dir}} && sudo docker compose logs --tail=100 --follow"

ps:
    ssh {{ssh_target}} "cd {{remote_app_dir}} && sudo docker compose ps"

ssh:
    ssh {{ssh_target}}

clean:
    rm -f {{release_archive_name}}

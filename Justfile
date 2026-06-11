set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

container := env_var_or_default("PREVIEW_CONTAINER", "countercast-home-preview")
base_image := env_var_or_default("JEKYLL_IMAGE", "jekyll/jekyll:4.2.2")
image := env_var_or_default("PREVIEW_IMAGE", "countercast-home-preview:local")
port := env_var_or_default("PREVIEW_PORT", "4000")
docs_dir := justfile_directory() / "docs"

# 利用可能なコマンドを表示する
default:
    @just --list

# GitHub Pages のプレビューコンテナを起動する
up:
    @docker rm --force "{{container}}" >/dev/null 2>&1 || true
    docker build \
        --build-arg "JEKYLL_IMAGE={{base_image}}" \
        --tag "{{image}}" \
        "{{justfile_directory()}}"
    docker run --detach \
        --name "{{container}}" \
        --publish "{{port}}:4000" \
        --volume "{{docs_dir}}:/srv/jekyll" \
        --workdir /srv/jekyll \
        "{{image}}"
    @echo "Preview: http://localhost:{{port}}"

# GitHub Pages のプレビューコンテナを再起動する
restart: down up

# GitHub Pages のプレビューコンテナを停止・削除する
down:
    @docker rm --force "{{container}}" >/dev/null 2>&1 || true

# プレビューコンテナのログを表示する
logs:
    docker logs --follow "{{container}}"

# プレビューコンテナの状態を表示する
status:
    @docker ps --all --filter "name=^/{{container}}$"

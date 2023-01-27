.DEFAULT_GOAL := help

.PHONY: build
build: ## 開発用コンテナ(lint用)をビルドする
	docker build . -t dev

.PHONY: copy
copy: ## 静的ファイルをコンテナからホストへコピーする
	docker compose cp doc:/usr/share/nginx/html ./

.PHONY: lint
lint: spectral yamllint openapi-validator ## すべてのLintを実行する

.PHONY: spectral
spectral: ## spectral lintを実行する
	docker run --rm -v ${PWD}:/work -w /work dev bash -c "npx @stoplight/spectral-cli lint openapi.yml"

.PHONY: yamllint
yamllint: ## yaml lintを実行する
	docker run --rm -v ${PWD}:/data cytopia/yamllint -s openapi.yml

.PHONY: openapi-validator
openapi-validator: ## openapi-validatorを実行する
	docker run --rm -v ${PWD}:/work jamescooke/openapi-validator --verbose --report_statistics /work/openapi.yml

.PHONY: help
help: ## ヘルプ表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

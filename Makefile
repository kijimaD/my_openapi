.DEFAULT_GOAL := help

.PHONY: build
build: ## 開発用コンテナ(lint用)をビルドする
	docker build . -t dev

.PHONY: gen
gen: ## 静的ファイルをコンテナからホストへコピーする
	docker run --rm -v ${PWD}:/work --workdir /work ghcr.io/redocly/redoc/cli build openapi.yml -o index.html

.PHONY: gen
gen: ## OpenAPI定義からHTMLを生成する
	docker run --rm -v ${PWD}:/work --workdir /work ghcr.io/redocly/redoc/cli build openapi.yml -o index.html \
	--options.theme.colors.primary.main=red \
	--options.hideDownloadButton=true \
	--options.theme.rightPanel.width=0%

.PHONY: lint
lint: spectral yamllint openapi-validator ## すべてのLintを実行する

.PHONY: spectral
spectral: ## spectral lintを実行する
	docker run --rm -v ${PWD}:/work -w /work stoplight/spectral lint openapi.yml

.PHONY: yamllint
yamllint: ## yaml lintを実行する
	docker run --rm -v ${PWD}:/data cytopia/yamllint -s openapi.yml

.PHONY: openapi-validator
openapi-validator: ## openapi-validatorを実行する
# 失敗する...
# docker run --rm -v ${PWD}:/work ibmdevxsdk/openapi-validator:1.13.0 /work/openapi.yml

.PHONY: help
help: ## ヘルプ表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

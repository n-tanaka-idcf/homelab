# Copilot 指示書（homelab）

## このリポジトリの前提(現状)
- IaC は `terraform/` 配下で管理する(入口: `terraform/Taskfile.yml`)。
- 実行コマンドは go-task の `task` に集約(`terraform plan/apply` 直叩きより task を優先)。
- 開発環境は devcontainer「terraform」が前提(`.devcontainer/terraform/devcontainer.json`)。
- CLI は aqua で固定(`.devcontainer/terraform/aqua.yaml`: `terraform`, `tflint`, `task`)。

## 主要ワークフロー(Terraform)
- `cd terraform` して task を実行:
	- 一覧: `task --list-all --sort none`
	- ツール確認: `task environment:check`
	- init: `task terraform:init`
	- plan/apply: `task terraform:plan -- [options]`, `task terraform:apply -- [options]` (どちらも `-var-file=terraform.tfvars` を固定付与)
	- destroy: `task terraform:destroy -- [options]` (必要なら `-var-file=...` は CLI args 側で明示)
	- lint/fmt: `task terraform:lint`, `task terraform:fmt`

## 変数・秘密情報(重要)
- `task pre-check` が `TF_VAR_api_key` と `TF_VAR_secret_key` を必須とする(未設定だと失敗)。
- `terraform.tfvars` は task から参照されるが、repo には置かれていない想定(秘密情報は repo 外)。
- `terraform/.gitignore` で state/秘密ファイルを除外(例: `.terraform/`, `*.tfstate`, `.envrc_common_secrets`)。

## Devcontainer の注意
- `.devcontainer/.env` に `UID`/`GID` を用意する運用(CI でも生成している)。
- `postCreateCommand` が aqua install を実行する(`.devcontainer/terraform/postCreateCommand.sh`)。

## 変更方針(プロジェクト固有)
- 1〜3 個の確認質問で対象環境/影響範囲(単一ホスト or クラスタ、OS、適用先)を確定してから進める。
- 小さく段階的に足場を作る(1 回に 1 つのツール/設定追加)。追加したら README の入口コマンドも更新。
- 破壊的操作(例: `terraform:destroy`)はデフォルトで実行しない。必要時はユーザー確認の上で提示する。

## CI(把握しておく)
- devcontainer CI: hadolint + devcontainer build 後に `task environment:check`(`.github/workflows/devcontainer_ci.yaml`)。
- workflow CI: actionlint(`.github/workflows/github_actions_workflow_ci.yaml`)。

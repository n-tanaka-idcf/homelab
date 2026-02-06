# Copilot 指示書（homelab）

## 全体像（Terraform）
- 実行単位は `terraform/environments/<env>/`（例: `terraform/environments/poc/`）。`main.tf` で `../../modules/compute` を呼び出す。
- `terraform/modules/compute/` は CloudStack で VM + 追加ディスク +（任意）IP/NAT + FW を作成。
  - `instances`/`disks`/`nat_instances`/`firewall_rules` は map で渡す（`for_each` 前提）。
	- `nat_instances` は「NAT を作る対象だけ」を map のキーとして渡す（値は実質使われない）。
	- `firewall_rules` のキーは `nat_instances` のキーと一致させる（IP を引くため）。
  - 出力は `ip_addresses`（instance 名→IP の map）など（`outputs.tf`）。
- Provider は `cloudstack/cloudstack@0.5.0`。認証情報は `TF_VAR_*` 経由で渡す（`providers.tf`）。

## 実行・開発の前提
- IaC は `terraform/` 配下で管理（Task の入口: `terraform/Taskfile.yml`）。
- `terraform plan/apply` の直叩きより go-task の `task` を優先。
- 開発環境は devcontainer「terraform」が前提（`.devcontainer/terraform/devcontainer.json`）。
- CLI は aqua で固定（`.devcontainer/terraform/aqua.yaml`）。Terraform は `v1.14.3` を使用。

## 主要ワークフロー(Terraform)

- 基本は「対象環境ディレクトリで」task を実行（例: `cd terraform/environments/poc`）。
	- 一覧: `task --list-all --sort none`
	- ツール確認: `task environment:check`
	- init: `task terraform:init`
	- plan/apply: `task terraform:plan -- [options]`, `task terraform:apply -- [options]`（どちらも `-var-file=terraform.tfvars` を固定付与）
	- destroy: `task terraform:destroy -- [options]`（破壊的操作なのでデフォルトで実行しない。必要時はユーザー確認）
	- lint/fmt: `task terraform:lint`, `task terraform:fmt`

- ルート（`cd terraform`）にも同等の Taskfile があるが、複数環境が増える前提では環境ディレクトリ実行を優先。

## 変数・秘密情報(重要)
- `task pre-check` が `TF_VAR_api_key` と `TF_VAR_secret_key` を必須とする（未設定だと失敗）。
- ローカルでは `cd terraform && . ./.envrc_common` のように env を読み込む運用がある（秘密は `terraform/.envrc_common_secrets` 側に置く）。
- 秘密情報はファイルへ直書きしない。`terraform/.envrc_common_secrets` 等は Git 管理外（`terraform/.gitignore` 参照）。
- state は `*.tfstate` を ignore。`terraform/environments/poc/terraform.tfstate` のようなファイルがあっても、コミット対象にしない前提で扱う。

## Devcontainer の注意
- `.devcontainer/.env` に `UID`/`GID` を用意する運用(CI でも生成している)。
- `postCreateCommand` が aqua install を実行する(`.devcontainer/terraform/postCreateCommand.sh`)。

## 変更時の作法（この repo 固有）
- module の入力/出力を変更したら、同時に環境側も更新する：
	- `terraform/modules/compute/variables.tf` / `outputs.tf`
	- `terraform/environments/poc/main.tf` / `variables.tf` / `outputs.tf`
- `terraform/modules/compute/main..tf` は現状このファイル名（リネームは不要）。

## 変更方針(プロジェクト固有)
- 1〜3 個の確認質問で対象環境/影響範囲(単一ホスト or クラスタ、OS、適用先)を確定してから進める。
- 小さく段階的に足場を作る(1 回に 1 つのツール/設定追加)。追加したら README の入口コマンドも更新。
- 破壊的操作(例: `terraform:destroy`)はデフォルトで実行しない。必要時はユーザー確認の上で提示する。

## CI(把握しておく)
- devcontainer CI: hadolint + devcontainer build 後に `task environment:check`(`.github/workflows/devcontainer_ci.yaml`)。
- workflow CI: actionlint(`.github/workflows/github_actions_workflow_ci.yaml`)。

## レビュー
- 日本語で行うこと。

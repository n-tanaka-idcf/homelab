# Copilot 指示書（homelab）

## 全体像
- この repo は Terraform（CloudStack）と Ansible を分離して管理する: `terraform/` と `ansible/`。
- Terraform は環境ディレクトリ単位で実行する（例: `terraform/environments/poc/`）。`main.tf` から `../../modules/compute` を呼び出す。
- module は `terraform/modules/compute/main..tf`（ファイル名は `main..tf` のまま）で VM + 追加ディスク +（任意）IP/NAT + FW を作成する。

## Terraform（CloudStack）規約
- 入力は map 前提（`for_each`）: `instances` / `disks` / `nat_instances` / `firewall_rules`（例は `terraform/environments/poc/terraform.tfvars`）。
- `nat_instances` は「NAT+IP を作る対象だけ」をキーに入れる（値は bool だが実質キー集合として扱う）。
- `firewall_rules` のキーは `nat_instances` のキーと一致させる（IP を引くため）。
- Provider は `cloudstack/cloudstack@0.5.0`（`terraform/modules/compute/versions.tf`）。

## 実行コマンド（Task 優先）
- Terraform: `cd terraform/environments/<env> && task environment:check && task terraform:init`（例: `<env>=poc`）
- Plan/Apply: `task terraform:plan -- [terraform options]` / `task terraform:apply -- [terraform options]`（`-var-file=terraform.tfvars` は Task 側で固定）
- Lint/Fmt: `task terraform:lint` / `task terraform:fmt`
- 破壊的操作: `task terraform:destroy` はデフォルトで実行しない（必要時はユーザー確認を取る）。

## 秘密情報・state
- `task pre-check` が `TF_VAR_api_key` と `TF_VAR_secret_key` を必須とする（未設定なら失敗）。秘密はファイルへ直書きしない。
- state（`*.tfstate`）は Git 管理外の前提。リポジトリ内に存在しても新規にコミットしない。

## Ansible 規約（Task + Inventory）
- 事前条件: `ANSIBLE_INVENTORY` が必要（例: `export ANSIBLE_INVENTORY=ansible/inventories/poc/hosts.ini`）。環境ごとに inventory を切り替える前提。
- 実行: `cd ansible && task ansible:ping -- all`、Playbook は `task playbook:dry-run -- <playbook.yml>` / `task playbook:run -- <playbook.yml>`。
- `ansible/inventories/<env>/hosts.ini` に `ansible_python_interpreter` や `ansible_ssh_common_args`（例: ProxyJump）など接続要件が書かれる。変更は対象環境の inventory に閉じ込める。

## 変更時の作法
- module の入力/出力を変えたら、環境側（`terraform/environments/poc/{main,variables,outputs}.tf`）も同時に更新する。
- レビュー/やり取りは日本語で行う。

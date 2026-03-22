#!/usr/bin/env bash
# scripts/lint.sh — 校正規約の自動チェック
# 使い方: bash scripts/lint.sh <ファイルパス>
#
# チェック項目:
#   1. 日本語直後の英数字（スペースなし）
#   2. 英数字直後の日本語（スペースなし）
#   3. 日本語直後の数字（スペースなし）
#   4. 数字直後の日本語（スペースなし）
#
# コードブロック（``` で囲まれた行）は除外する。
# HTML 属性値内（title="..."）などの誤検知は無視してよい。

set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "使い方: $0 <ファイルパス>" >&2
  exit 1
fi

FILE="$1"

if [[ ! -f "$FILE" ]]; then
  echo "エラー: ファイルが見つかりません: $FILE" >&2
  exit 1
fi

# コードブロック内の行を除去した一時ファイルを生成
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

awk '
  /^```/ { in_code = !in_code; next }
  in_code { next }
  { print NR": "$0 }
' "$FILE" > "$TMPFILE"

ERRORS=0

check() {
  local label="$1"
  local pat="$2"
  local out
  out=$(rg -n "$pat" "$TMPFILE" || true)
  if [[ -n "$out" ]]; then
    echo "[${label}]"
    echo "$out"
    echo
    ERRORS=$((ERRORS + 1))
  fi
}

echo "=== lint: $FILE ==="
echo

# 日本語（ひらがな・カタカナ・漢字）と英字の境界
check "日本語→英字（スペースなし）" "[ぁ-んァ-ン一-龥々ー][a-zA-Z]"
check "英字→日本語（スペースなし）" "[a-zA-Z][ぁ-んァ-ン一-龥々ー]"

# 日本語と数字の境界
check "日本語→数字（スペースなし）" "[ぁ-んァ-ン一-龥々ー][0-9]"
check "数字→日本語（スペースなし）" "[0-9][ぁ-んァ-ン一-龥々ー]"

if [[ $ERRORS -eq 0 ]]; then
  echo "問題なし。"
else
  echo "上記 $ERRORS 種類の違反が見つかりました。"
  echo "注意: HTML 属性値（title=\"...\"）内のマッチは無視してください。"
fi

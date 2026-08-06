#!/bin/sh
# 全画像について jsDelivr 経由の公開URLが
#   HTTP 200 / Content-Type image/jpeg / ローカルとバイト数一致
# であることを確認する。Amazonへ画像URLを渡す前に必ず通す。
#
#   使い方:  sh "C:/Users/owner/Desktop/日本ネオン/LED_PRO_SHOP/Amazon/images-host/verify.sh"
#
# 2026-08-06 初回実行: 36件中36件一致・不一致0

cd "$(dirname "$0")" || exit 1
BASE="https://cdn.jsdelivr.net/gh/nihonneon2025/led-proshop-images@main"
ok=0; ng=0
for f in $(find . -type f -name '*.jpg' | sed 's|^\./||' | sort); do
  local_size=$(stat -c %s "$f")
  res=$(curl -s -o /dev/null -w "%{http_code} %{content_type} %{size_download}" "$BASE/$f")
  code=$(echo "$res" | cut -d' ' -f1)
  ctype=$(echo "$res" | cut -d' ' -f2)
  rsize=$(echo "$res" | cut -d' ' -f3)
  if [ "$code" = "200" ] && [ "$ctype" = "image/jpeg" ] && [ "$rsize" = "$local_size" ]; then
    ok=$((ok+1))
  else
    ng=$((ng+1))
    echo "NG $f  code=$code type=$ctype remote=$rsize local=$local_size"
  fi
done
echo "----"
echo "一致 $ok 件 / 不一致 $ng 件"
[ "$ng" = "0" ] || exit 1

# led-proshop-images — Amazon出品用 画像ホスティング

Amazon SP-API（Listings API）の `main_product_image_locator` / `other_product_image_locator_1..8` は
**画像ファイルを添付できず、公開URLしか受け付けない**。その公開先がこのリポジトリ。

## なぜカタログサイト（Netlify）から分けたか

2026-08-06、Netlifyがクレジット制（**本番デプロイ1回=15クレジット**）になっており、
Amazon画像を1枚直すたびにカタログサイトへ本番反映していたため、8/6だけで4回=60クレジットを消費。
7/28〜8/6の10日で無料枠300の75%に到達し、枯渇するとサイト全体が停止する状態だった。
GitHubへのpushは回数課金がないため、Amazon用画像の置き場をここへ分離した（社長決裁 2026-08-06）。

## Amazonに渡す公開URL（正）

**jsDelivr CDN を使う。** `@main` はブランチ名。

```
https://cdn.jsdelivr.net/gh/nihonneon2025/led-proshop-images@main/amazon/main_v3/COB24-GD_main_v3.jpg
https://cdn.jsdelivr.net/gh/nihonneon2025/led-proshop-images@main/amazon-sub/tape/spec_COB24-RD.jpg
https://cdn.jsdelivr.net/gh/nihonneon2025/led-proshop-images@main/amazon-sub/frame/spec_normal-black-25mm.jpg
```

2026-08-06 に全36枚を検証済み（HTTP 200 / `image/jpeg` / ローカルとバイト数一致・36件中36件）。

- **GitHub Pages（`nihonneon2025.github.io`）は使わない**。有効化を試みたが `Page build failed.` が連続し
  404 のままだった（2026-08-06）。将来直っても、URLはjsDelivrで統一する。
- 予備の経路として `https://raw.githubusercontent.com/nihonneon2025/led-proshop-images/main/...` も
  200 / `image/jpeg` で取得できることを確認済み（ホットリンク用途としてはjsDelivrが正）。

## 運用ルール

- **画像の正本は `05_EC運用/images/` 側**。ここはAmazonへ渡すための公開コピー。
- 差し替えるときは **必ず別ファイル名**にする（同一URLではAmazon側のCDNが更新されない）。
- 旧ファイルは消さない（Amazonが再取得に来る可能性があるため）。
- カタログサイト（www.led-proshop.com）に既に置いてあるAmazon画像も**消さない**（同上）。
- ここへのpushはNetlifyのクレジットを一切消費しない。カタログサイトの本番反映は
  「商品ページそのものを直すとき」だけに絞る。

## 出品スクリプト側の切り替えが未了（次のAmazon作業で対応）

`Amazon\scripts\` 配下に `https://www.led-proshop.com/` が接頭として直書きされており、
さらに「この接頭で始まらなければ中断」というガードが入っている。**両方のURLを許可する形**に直す
（既存の出品済み画像URLを壊さないため、旧接頭も許可のまま残す）。対象:

| ファイル | 箇所 |
|---|---|
| `subimages_20260806/_common.js` | `PUBLIC_BASE`（41行目） |
| `subimages_20260806/05-build-patch-payloads.js` | `公開ベース`（47行目）＋ガード（22行目） |
| `subimages_20260806/09-apply-subimages.js` | `公開URL接頭`（53行目）＋ガードS6（26行目） |
| `subimages_20260806/07-preapply-gate-and-diff.js` | 表示整形（169行目） |
| `subimages_20260806/10-restore-main-image.js` | `公開URL接頭`（61行目）＋ガードM2（27行目） |
| `mainimage_20260806/21-replace-main-image.js` | `公開URL接頭`（48行目）＋ガードG2（23行目） |
| `batch3_silicone_20260806/06-build-drafts.js` | `画像ベース`（18行目） |
| `batch1_20260805/06-extract-site-data.js` | `PUBLIC_BASE`（74行目） |

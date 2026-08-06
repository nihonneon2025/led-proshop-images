# led-proshop-images — Amazon出品用 画像ホスティング

Amazon SP-API（Listings API）の `main_product_image_locator` / `other_product_image_locator_1..8` は
**画像ファイルを添付できず、公開URLしか受け付けない**。その公開先がこのリポジトリ（GitHub Pages）。

## なぜカタログサイト（Netlify）から分けたか

2026-08-06、Netlifyがクレジット制（無料枠300/月・**本番デプロイ1回=15クレジット**）になっており、
Amazon画像を1枚直すたびにカタログサイトへ本番反映していたため、8/6だけで4回=60クレジットを消費。
7/28〜8/6の10日で75%（225）に到達し、枯渇するとサイト全体が停止する状態だった。
GitHub Pagesは公開回数に課金がないため、Amazon用画像の置き場をここへ分離した（社長決裁 2026-08-06）。

## 公開URLの形

```
https://nihonneon2025.github.io/led-proshop-images/amazon/main_v3/COB24-GD_main_v3.jpg
https://nihonneon2025.github.io/led-proshop-images/amazon-sub/tape/xxxxx.jpg
```

## 運用ルール

- **画像の正本は `05_EC運用/images/` 側**。ここはAmazonへ渡すための公開コピー。
- 差し替えるときは **必ず別ファイル名**にする（同一URLではAmazon側のCDNが更新されない）。
- 旧ファイルは消さない（Amazonが再取得に来る可能性があるため）。
- カタログサイト（www.led-proshop.com）に既に置いてあるAmazon画像も**消さない**（同上）。
- ここへのpushはNetlifyのクレジットを一切消費しない。カタログサイトの本番反映は
  「商品ページそのものを直すとき」だけに絞る。

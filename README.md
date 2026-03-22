# proofreading-ai

ブログ記事の校閲・校正を Claude Code で行うリポジトリです。

## ディレクトリ構成

```
proofreading-ai/
├── drafts/          # 校正前の原稿置き場（.gitignore対象）
├── results/         # 校正結果の出力先（.gitignore対象）
├── .claude/
│   └── skills/
│       └── proofread/
│           └── SKILL.md   # /proofread スキル定義
├── CLAUDE.md        # 校正規約（Claude が参照）
└── README.md
```

`drafts/` と `results/` は `.gitignore` に含まれるため、原稿はリポジトリに残りません。
スキル定義・校正規約のみがコミット対象です。

## 使い方

1. **原稿を配置する**

   ```
   drafts/article.md
   ```

2. **Claude Code でスキルを呼び出す**

   ```
   /proofread drafts/article.md
   ```

   または自然言語で依頼することもできます。

   ```
   drafts/article.md を校閲・校正してください
   ```

3. **出力を確認する**

   Claude が以下を順番に行います。

   - **校閲フェーズ**: 内容の改善提案（表現・事実確認・構成）を提示し、承認後に適用
   - **校正フェーズ**: 校正規約に基づく誤植・体裁の修正を提示し、承認後に適用

   最終的な校正済みファイルが `results/article.md` に保存されます。

## 校正規約

詳細は [CLAUDE.md](./CLAUDE.md) を参照してください。

# 📱 todo_app タスク管理アプリ

## 概要

Flutterを用いて開発したシンプルなタスク管理アプリです。
タスクの追加・編集・削除に加え、カレンダー表示やテーマ変更などの機能を実装しています。

日々のタスクを直感的に管理できるよう、UI/UXを意識して開発しました。

## デモ

![アプリデモ](assets/画面録画%202026-03-14%20124856.gif)

---

## ✨ 主な機能

### 🏠 ホーム（タスク管理）

* タスクの追加
* タスクの編集
* タスクの削除（スワイプ削除）
* タスク検索
* タスクの完了チェック
* タスクの着手状態管理
* 重要タスクの設定

### 📅 カレンダー

* タスクの期日をカレンダーで表示
* タスク状態による色分け表示

  * 🟠 重要タスク
  * 🔵 着手中タスク
  * 🟢 完了タスク

* 日付をタップするとその日のタスク一覧を表示

### ⚙ 設定

* ダークモード切り替え
* アプリのテーマカラー変更
* カレンダーのマーク説明表示

---

## 🛠 使用技術

### 言語・フレームワーク

* Flutter
* Dart

### 主なパッケージ

* `table_calendar`（カレンダー表示）
* `shared_preferences`（ローカルデータ保存）
* `intl`（日付フォーマット）

---

## 💻 動作環境

* Flutter 3.38.9
* Dart 3.10.8
* Android / iOS / Web

---

## 📦 インストール方法

```bash
# リポジトリをクローン
git clone https://github.com/s1F102401449/todo_app.git

# ディレクトリ移動
cd todo_app

# 依存パッケージをインストール
flutter pub get
```

---

## ▶ 実行方法

```bash
# アプリを起動
flutter run
```

---

## 📁 ディレクトリ構成

```
lib 
├── models 
│ └── todo.dart 
│ 
├── screens 
│ ├── add_todo_screen.dart 
│ ├── calendar_screen.dart 
│ ├── home_screen.dart
│ ├── list_screen.dart
│ ├── settings_screen.dart
│ └── task_detail_screen.dart 
│ 
├── services 
│ ├── settings_service.dart 
│ └── todo_service.dart 
│ 
├── widgets 
│ ├── todo_card.dart  
│ └── todo_list.dart 
│ 
└── main.dart
```

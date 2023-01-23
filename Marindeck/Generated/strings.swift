// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum ActionButton {
    internal enum Debug {
      /// デバッグモーダルを開く
      internal static let description = L10n.tr("Localizable", "actionButton.debug.description", fallback: "デバッグモーダルを開く")
      /// デバッグ
      internal static let title = L10n.tr("Localizable", "actionButton.debug.title", fallback: "デバッグ")
    }
    internal enum Description {
      /// ツイートボタンを長押ししたときに出てくるアクションボタンを設定できます。
      internal static let title = L10n.tr("Localizable", "actionButton.description.title", fallback: "ツイートボタンを長押ししたときに出てくるアクションボタンを設定できます。")
    }
    internal enum Draft {
      /// 下書きを開く
      internal static let description = L10n.tr("Localizable", "actionButton.draft.description", fallback: "下書きを開く")
      /// ドラフト
      internal static let title = L10n.tr("Localizable", "actionButton.draft.title", fallback: "ドラフト")
    }
    internal enum Gif {
      /// GIFを選ぶ
      internal static let description = L10n.tr("Localizable", "actionButton.gif.description", fallback: "GIFを選ぶ")
      /// GIF
      internal static let title = L10n.tr("Localizable", "actionButton.gif.title", fallback: "GIF")
    }
    internal enum Menu {
      /// メニューを開く
      internal static let description = L10n.tr("Localizable", "actionButton.menu.description", fallback: "メニューを開く")
      /// メニュー
      internal static let title = L10n.tr("Localizable", "actionButton.menu.title", fallback: "メニュー")
    }
    internal enum Settings {
      /// 設定を開く
      internal static let description = L10n.tr("Localizable", "actionButton.settings.description", fallback: "設定を開く")
      /// 設定
      internal static let title = L10n.tr("Localizable", "actionButton.settings.title", fallback: "設定")
    }
    internal enum Tweet {
      /// ツイートモーダルを開く
      internal static let description = L10n.tr("Localizable", "actionButton.tweet.description", fallback: "ツイートモーダルを開く")
      /// ツイート
      internal static let title = L10n.tr("Localizable", "actionButton.tweet.title", fallback: "ツイート")
    }
  }
  internal enum Alert {
    internal enum Ok {
      /// OK
      internal static let title = L10n.tr("Localizable", "alert.OK.title", fallback: "OK")
    }
    internal enum Cancel {
      /// キャンセル
      internal static let title = L10n.tr("Localizable", "alert.cancel.title", fallback: "キャンセル")
    }
    internal enum Close {
      /// 閉じる
      internal static let title = L10n.tr("Localizable", "alert.close.title", fallback: "閉じる")
    }
    internal enum ImportedSettings {
      /// 設定をインポートしました。
      internal static let title = L10n.tr("Localizable", "alert.importedSettings.title", fallback: "設定をインポートしました。")
    }
    internal enum LogoutMessage {
      /// ログアウトしますか？
      internal static let title = L10n.tr("Localizable", "alert.logoutMessage.title", fallback: "ログアウトしますか？")
    }
    internal enum Open {
      /// 開く
      internal static let title = L10n.tr("Localizable", "alert.open.title", fallback: "開く")
    }
    internal enum OpenUrl {
      /// URLを開きますか？
      internal static let title = L10n.tr("Localizable", "alert.openUrl.title", fallback: "URLを開きますか？")
    }
    internal enum RecommendRestartApp {
      /// アプリ再起動をおすすめします。
      internal static let title = L10n.tr("Localizable", "alert.recommendRestartApp.title", fallback: "アプリ再起動をおすすめします。")
    }
    internal enum Update {
      /// 更新
      internal static let title = L10n.tr("Localizable", "alert.update.title", fallback: "更新")
    }
  }
  internal enum ContextMenu {
    internal enum Like {
      /// いいね
      internal static let title = L10n.tr("Localizable", "contextMenu.like.title", fallback: "いいね")
    }
    internal enum SaveImage {
      /// 画像を保存
      internal static let title = L10n.tr("Localizable", "contextMenu.saveImage.title", fallback: "画像を保存")
    }
    internal enum Saved {
      /// 保存しました
      internal static let title = L10n.tr("Localizable", "contextMenu.saved.title", fallback: "保存しました")
    }
    internal enum TweetImage {
      /// 画像をツイート
      internal static let title = L10n.tr("Localizable", "contextMenu.tweetImage.title", fallback: "画像をツイート")
    }
  }
  internal enum Menu {
    internal enum AddColumn {
      /// カラムを追加
      internal static let title = L10n.tr("Localizable", "menu.addColumn.title", fallback: "カラムを追加")
    }
    internal enum Profile {
      /// プロフィール
      internal static let title = L10n.tr("Localizable", "menu.profile.title", fallback: "プロフィール")
    }
    internal enum Reload {
      /// リロード
      internal static let title = L10n.tr("Localizable", "menu.reload.title", fallback: "リロード")
    }
  }
  internal enum OnBoarding {
    internal enum StartMarinDeck {
      /// MarinDeckをはじめる
      internal static let title = L10n.tr("Localizable", "onBoarding.startMarinDeck.title", fallback: "MarinDeckをはじめる")
    }
  }
  internal enum Settings {
    internal enum Appinfo {
      internal enum Header {
        /// アプリについて
        internal static let title = L10n.tr("Localizable", "settings.appinfo.header.title", fallback: "アプリについて")
      }
    }
    internal enum Biometrics {
      internal enum Cell {
        /// 生体認証
        internal static let title = L10n.tr("Localizable", "settings.biometrics.cell.title", fallback: "生体認証")
      }
    }
    internal enum CheckUpdate {
      internal enum Cell {
        /// 更新を確認
        internal static let title = L10n.tr("Localizable", "settings.checkUpdate.cell.title", fallback: "更新を確認")
      }
      internal enum CheckingForUpdates {
        /// 更新を確認
        internal static let title = L10n.tr("Localizable", "settings.checkUpdate.checkingForUpdates.title", fallback: "更新を確認")
      }
      internal enum ExistUpdate {
        /// 更新があります
        internal static let title = L10n.tr("Localizable", "settings.checkUpdate.existUpdate.title", fallback: "更新があります")
      }
      internal enum Latest {
        /// 最新です
        internal static let title = L10n.tr("Localizable", "settings.checkUpdate.latest.title", fallback: "最新です")
      }
    }
    internal enum CustomActonButtons {
      internal enum Cell {
        /// カスタムアクションボタン
        internal static let title = L10n.tr("Localizable", "settings.customActonButtons.cell.title", fallback: "カスタムアクションボタン")
      }
    }
    internal enum CustomCSS {
      internal enum Cell {
        /// カスタムCSS
        internal static let title = L10n.tr("Localizable", "settings.customCSS.cell.title", fallback: "カスタムCSS")
      }
    }
    internal enum CustomJS {
      internal enum Cell {
        /// カスタムJavaScript
        internal static let title = L10n.tr("Localizable", "settings.customJS.cell.title", fallback: "カスタムJavaScript")
      }
    }
    internal enum Customize {
      internal enum Header {
        /// カスタマイズ
        internal static let title = L10n.tr("Localizable", "settings.customize.header.title", fallback: "カスタマイズ")
      }
    }
    internal enum Developers {
      internal enum Cell {
        /// 開発者
        internal static let title = L10n.tr("Localizable", "settings.developers.cell.title", fallback: "開発者")
      }
    }
    internal enum Donate {
      internal enum Cell {
        /// 寄付
        internal static let title = L10n.tr("Localizable", "settings.donate.cell.title", fallback: "寄付")
      }
      internal enum Header {
        /// 寄付
        internal static let title = L10n.tr("Localizable", "settings.donate.header.title", fallback: "寄付")
      }
    }
    internal enum ExportSettings {
      internal enum Cell {
        /// 設定をエクスポート
        internal static let title = L10n.tr("Localizable", "settings.exportSettings.cell.title", fallback: "設定をエクスポート")
      }
    }
    internal enum General {
      internal enum Header {
        /// 一般
        internal static let title = L10n.tr("Localizable", "settings.general.header.title", fallback: "一般")
      }
    }
    internal enum Icon {
      internal enum Cell {
        /// アイコン
        internal static let title = L10n.tr("Localizable", "settings.icon.cell.title", fallback: "アイコン")
      }
    }
    internal enum ImportSettings {
      internal enum Cell {
        /// 設定をインポート
        internal static let title = L10n.tr("Localizable", "settings.importSettings.cell.title", fallback: "設定をインポート")
      }
    }
    internal enum IssueEnhancement {
      internal enum Cell {
        /// ご意見・ご要望
        internal static let title = L10n.tr("Localizable", "settings.issueEnhancement.cell.title", fallback: "ご意見・ご要望")
      }
    }
    internal enum License {
      internal enum Cell {
        /// ライセンス
        internal static let title = L10n.tr("Localizable", "settings.license.cell.title", fallback: "ライセンス")
      }
    }
    internal enum Logout {
      internal enum Cell {
        /// ログアウト
        internal static let title = L10n.tr("Localizable", "settings.logout.cell.title", fallback: "ログアウト")
      }
      internal enum Header {
        /// ログアウト
        internal static let title = L10n.tr("Localizable", "settings.logout.header.title", fallback: "ログアウト")
      }
    }
    internal enum MarginSafeArea {
      internal enum Cell {
        /// SafeAreaを考慮する
        internal static let title = L10n.tr("Localizable", "settings.marginSafeArea.cell.title", fallback: "SafeAreaを考慮する")
      }
    }
    internal enum NativePreview {
      internal enum Cell {
        /// ネイティブのプレビューを使用
        internal static let title = L10n.tr("Localizable", "settings.nativePreview.cell.title", fallback: "ネイティブのプレビューを使用")
      }
    }
    internal enum Navigation {
      /// 設定
      internal static let title = L10n.tr("Localizable", "settings.navigation.title", fallback: "設定")
    }
    internal enum NoSleep {
      internal enum Cell {
        /// スリープさせない
        internal static let title = L10n.tr("Localizable", "settings.noSleep.cell.title", fallback: "スリープさせない")
      }
    }
    internal enum TermsOfUse {
      internal enum Cell {
        /// 利用規約
        internal static let title = L10n.tr("Localizable", "settings.termsOfUse.cell.title", fallback: "利用規約")
      }
    }
    internal enum Theme {
      internal enum Cell {
        /// テーマ
        internal static let title = L10n.tr("Localizable", "settings.theme.cell.title", fallback: "テーマ")
      }
    }
    internal enum TweetButtonBehavior {
      internal enum Cell {
        /// ツイートボタンの動作
        internal static let title = L10n.tr("Localizable", "settings.tweetButtonBehavior.cell.title", fallback: "ツイートボタンの動作")
      }
    }
    internal enum Version {
      internal enum Cell {
        /// バージョン
        internal static let title = L10n.tr("Localizable", "settings.version.cell.title", fallback: "バージョン")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

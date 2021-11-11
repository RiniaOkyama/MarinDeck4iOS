// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum ActionButton {
    internal enum Debug {
      /// デバッグ
      internal static let title = L10n.tr("Localizable", "actionButton.debug.title")
    }
    internal enum Draft {
      /// ドラフト
      internal static let title = L10n.tr("Localizable", "actionButton.draft.title")
    }
    internal enum Gif {
      /// GIF
      internal static let title = L10n.tr("Localizable", "actionButton.gif.title")
    }
    internal enum Menu {
      /// メニュー
      internal static let title = L10n.tr("Localizable", "actionButton.menu.title")
    }
    internal enum Settings {
      /// 設定
      internal static let title = L10n.tr("Localizable", "actionButton.settings.title")
    }
    internal enum Tweet {
      /// ツイート
      internal static let title = L10n.tr("Localizable", "actionButton.tweet.title")
    }
  }

  internal enum Menu {
    internal enum EditColumn {
      /// カラムを編集
      internal static let title = L10n.tr("Localizable", "menu.editColumn.title")
    }
    internal enum Profile {
      /// プロフィール
      internal static let title = L10n.tr("Localizable", "menu.profile.title")
    }
    internal enum Reload {
      /// リロード
      internal static let title = L10n.tr("Localizable", "menu.reload.title")
    }
  }

  internal enum OnBoarding {
    internal enum StartMarinDeck {
      /// MarinDeckをはじめる
      internal static let title = L10n.tr("Localizable", "onBoarding.startMarinDeck.title")
    }
  }

  internal enum Settings {
    internal enum Appinfo {
      internal enum Header {
        /// アプリについて
        internal static let title = L10n.tr("Localizable", "settings.appinfo.header.title")
      }
    }
    internal enum Biometrics {
      internal enum Cell {
        /// 生体認証
        internal static let title = L10n.tr("Localizable", "settings.biometrics.cell.title")
      }
    }
    internal enum CustomCSS {
      internal enum Cell {
        /// カスタムCSS
        internal static let title = L10n.tr("Localizable", "settings.customCSS.cell.title")
      }
    }
    internal enum CustomJS {
      internal enum Cell {
        /// カスタムJavaScript
        internal static let title = L10n.tr("Localizable", "settings.customJS.cell.title")
      }
    }
    internal enum Customize {
      internal enum Header {
        /// カスタマイズ
        internal static let title = L10n.tr("Localizable", "settings.customize.header.title")
      }
    }
    internal enum Developers {
      internal enum Cell {
        /// 開発者
        internal static let title = L10n.tr("Localizable", "settings.developers.cell.title")
      }
    }
    internal enum Donate {
      internal enum Cell {
        /// 寄付
        internal static let title = L10n.tr("Localizable", "settings.donate.cell.title")
      }
    }
    internal enum ExportSettings {
      internal enum Cell {
        /// 設定をエクスポート
        internal static let title = L10n.tr("Localizable", "settings.exportSettings.cell.title")
      }
    }
    internal enum General {
      internal enum Header {
        /// 一般
        internal static let title = L10n.tr("Localizable", "settings.general.header.title")
      }
    }
    internal enum ImportSettings {
      internal enum Cell {
        /// 設定をインポート
        internal static let title = L10n.tr("Localizable", "settings.importSettings.cell.title")
      }
    }
    internal enum IssueEnhancement {
      internal enum Cell {
        /// ご意見・ご要望
        internal static let title = L10n.tr("Localizable", "settings.issueEnhancement.cell.title")
      }
    }
    internal enum License {
      internal enum Cell {
        /// ライセンス
        internal static let title = L10n.tr("Localizable", "settings.license.cell.title")
      }
    }
    internal enum Logout {
      internal enum Cell {
        /// ログアウト
        internal static let title = L10n.tr("Localizable", "settings.logout.cell.title")
      }
      internal enum Header {
        /// ログアウト
        internal static let title = L10n.tr("Localizable", "settings.logout.header.title")
      }
    }
    internal enum NativePreview {
      internal enum Cell {
        /// ネイティブのプレビューを使用
        internal static let title = L10n.tr("Localizable", "settings.nativePreview.cell.title")
      }
    }
    internal enum NativeTweetModal {
      internal enum Cell {
        /// ネイティブのツイート画面を使用
        internal static let title = L10n.tr("Localizable", "settings.nativeTweetModal.cell.title")
      }
    }
    internal enum Navigation {
      /// 設定
      internal static let title = L10n.tr("Localizable", "settings.navigation.title")
    }
    internal enum TermsOfUse {
      internal enum Cell {
        /// 利用規約
        internal static let title = L10n.tr("Localizable", "settings.termsOfUse.cell.title")
      }
    }
    internal enum Theme {
      internal enum Cell {
        /// テーマ
        internal static let title = L10n.tr("Localizable", "settings.theme.cell.title")
      }
    }
    internal enum Version {
      internal enum Cell {
        /// バージョン
        internal static let title = L10n.tr("Localizable", "settings.version.cell.title")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
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

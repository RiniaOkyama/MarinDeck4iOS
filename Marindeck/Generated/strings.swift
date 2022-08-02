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
            /// デバッグモーダルを開く
            internal static let description = L10n.tr("Localizable", "actionButton.debug.description")
            /// デバッグ
            internal static let title = L10n.tr("Localizable", "actionButton.debug.title")
        }
        internal enum Description {
            /// ツイートボタンを長押ししたときに出てくるアクションボタンを設定できます。
            internal static let title = L10n.tr("Localizable", "actionButton.description.title")
        }
        internal enum Draft {
            /// 下書きを開く
            internal static let description = L10n.tr("Localizable", "actionButton.draft.description")
            /// ドラフト
            internal static let title = L10n.tr("Localizable", "actionButton.draft.title")
        }
        internal enum Gif {
            /// GIFを選ぶ
            internal static let description = L10n.tr("Localizable", "actionButton.gif.description")
            /// GIF
            internal static let title = L10n.tr("Localizable", "actionButton.gif.title")
        }
        internal enum Menu {
            /// メニューを開く
            internal static let description = L10n.tr("Localizable", "actionButton.menu.description")
            /// メニュー
            internal static let title = L10n.tr("Localizable", "actionButton.menu.title")
        }
        internal enum Settings {
            /// 設定を開く
            internal static let description = L10n.tr("Localizable", "actionButton.settings.description")
            /// 設定
            internal static let title = L10n.tr("Localizable", "actionButton.settings.title")
        }
        internal enum Tweet {
            /// ツイートモーダルを開く
            internal static let description = L10n.tr("Localizable", "actionButton.tweet.description")
            /// ツイート
            internal static let title = L10n.tr("Localizable", "actionButton.tweet.title")
        }
    }

    internal enum Alert {
        internal enum Ok {
            /// OK
            internal static let title = L10n.tr("Localizable", "alert.OK.title")
        }
        internal enum Cancel {
            /// キャンセル
            internal static let title = L10n.tr("Localizable", "alert.cancel.title")
        }
        internal enum Close {
            /// 閉じる
            internal static let title = L10n.tr("Localizable", "alert.close.title")
        }
        internal enum ImportedSettings {
            /// 設定をインポートしました。
            internal static let title = L10n.tr("Localizable", "alert.importedSettings.title")
        }
        internal enum LogoutMessage {
            /// ログアウトしますか？
            internal static let title = L10n.tr("Localizable", "alert.logoutMessage.title")
        }
        internal enum Open {
            /// 開く
            internal static let title = L10n.tr("Localizable", "alert.open.title")
        }
        internal enum OpenUrl {
            /// URLを開きますか？
            internal static let title = L10n.tr("Localizable", "alert.openUrl.title")
        }
        internal enum RecommendRestartApp {
            /// アプリ再起動をおすすめします。
            internal static let title = L10n.tr("Localizable", "alert.recommendRestartApp.title")
        }
        internal enum Update {
            /// 更新
            internal static let title = L10n.tr("Localizable", "alert.update.title")
        }
    }

    internal enum ContextMenu {
        internal enum Like {
            /// いいね
            internal static let title = L10n.tr("Localizable", "contextMenu.like.title")
        }
        internal enum SaveImage {
            /// 画像を保存
            internal static let title = L10n.tr("Localizable", "contextMenu.saveImage.title")
        }
        internal enum Saved {
            /// 保存しました
            internal static let title = L10n.tr("Localizable", "contextMenu.saved.title")
        }
        internal enum TweetImage {
            /// 画像をツイート
            internal static let title = L10n.tr("Localizable", "contextMenu.tweetImage.title")
        }
    }

    internal enum Menu {
        internal enum AddColumn {
            /// カラムを追加
            internal static let title = L10n.tr("Localizable", "menu.addColumn.title")
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
        internal enum CheckUpdate {
            internal enum Cell {
                /// 更新を確認
                internal static let title = L10n.tr("Localizable", "settings.checkUpdate.cell.title")
            }
            internal enum CheckingForUpdates {
                /// 更新を確認
                internal static let title = L10n.tr("Localizable", "settings.checkUpdate.checkingForUpdates.title")
            }
            internal enum ExistUpdate {
                /// 更新があります
                internal static let title = L10n.tr("Localizable", "settings.checkUpdate.existUpdate.title")
            }
            internal enum Latest {
                /// 最新です
                internal static let title = L10n.tr("Localizable", "settings.checkUpdate.latest.title")
            }
        }
        internal enum CustomActonButtons {
            internal enum Cell {
                /// カスタムアクションボタン
                internal static let title = L10n.tr("Localizable", "settings.customActonButtons.cell.title")
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
        internal enum Icon {
            internal enum Cell {
                /// アイコン
                internal static let title = L10n.tr("Localizable", "settings.icon.cell.title")
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
        internal enum MarginSafeArea {
            internal enum Cell {
                /// SafeAreaを考慮する
                internal static let title = L10n.tr("Localizable", "settings.marginSafeArea.cell.title")
            }
        }
        internal enum NativePreview {
            internal enum Cell {
                /// ネイティブのプレビューを使用
                internal static let title = L10n.tr("Localizable", "settings.nativePreview.cell.title")
            }
        }
        internal enum Navigation {
            /// 設定
            internal static let title = L10n.tr("Localizable", "settings.navigation.title")
        }
        internal enum NoSleep {
            internal enum Cell {
                /// スリープさせない
                internal static let title = L10n.tr("Localizable", "settings.noSleep.cell.title")
            }
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
        internal enum TweetButtonBehavior {
            internal enum Cell {
                /// ツイートボタンの動作
                internal static let title = L10n.tr("Localizable", "settings.tweetButtonBehavior.cell.title")
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

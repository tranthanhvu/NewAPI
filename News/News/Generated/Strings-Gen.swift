// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Error {
    /// Error %d
    internal static func codeTitle(_ p1: Int) -> String {
      return L10n.tr("Localizable", "error.codeTitle", p1)
    }
  }

  internal enum Profile {
    /// Category
    internal static let category = L10n.tr("Localizable", "profile.category")
    /// Register
    internal static let register = L10n.tr("Localizable", "profile.register")
    /// Sign Out
    internal static let signOut = L10n.tr("Localizable", "profile.signOut")
    /// User name
    internal static let userName = L10n.tr("Localizable", "profile.userName")
    internal enum InputName {
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "profile.inputName.cancel")
      /// It will be used to register your account.
      internal static let message = L10n.tr("Localizable", "profile.inputName.message")
      /// Register
      internal static let ok = L10n.tr("Localizable", "profile.inputName.ok")
      /// Please input your name!
      internal static let title = L10n.tr("Localizable", "profile.inputName.title")
    }
    internal enum SelectCategory {
      /// We will use it to filter articles in News.
      internal static let message = L10n.tr("Localizable", "profile.selectCategory.message")
      /// Which category would you refer?
      internal static let title = L10n.tr("Localizable", "profile.selectCategory.title")
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

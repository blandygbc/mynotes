import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_pt.dart';

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @my_title.
  ///
  /// In en, this message translates to:
  /// **'My title goes here'**
  String get my_title;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @sharing.
  ///
  /// In en, this message translates to:
  /// **'Sharing'**
  String get sharing;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @verify_email.
  ///
  /// In en, this message translates to:
  /// **'Verify email'**
  String get verify_email;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @start_typing_your_note.
  ///
  /// In en, this message translates to:
  /// **'Start typing your note'**
  String get start_typing_your_note;

  /// No description provided for @delete_note_prompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this note?'**
  String get delete_note_prompt;

  /// No description provided for @cannot_share_empty_note_prompt.
  ///
  /// In en, this message translates to:
  /// **'Cannot share an empty note!'**
  String get cannot_share_empty_note_prompt;

  /// No description provided for @generic_error_prompt.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get generic_error_prompt;

  /// No description provided for @generic_error_unpredicted.
  ///
  /// In en, this message translates to:
  /// **'Unpredicted error occurred'**
  String get generic_error_unpredicted;

  /// No description provided for @logout_dialog_prompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logout_dialog_prompt;

  /// No description provided for @password_reset.
  ///
  /// In en, this message translates to:
  /// **'Password reset'**
  String get password_reset;

  /// No description provided for @password_reset_dialog_prompt.
  ///
  /// In en, this message translates to:
  /// **'We have now sent you a password reset link. Please check your email for more information.'**
  String get password_reset_dialog_prompt;

  /// No description provided for @login_error_cannot_find_user.
  ///
  /// In en, this message translates to:
  /// **'Cannot find a user with the entered credentials!'**
  String get login_error_cannot_find_user;

  /// No description provided for @login_error_wrong_credentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong credentials'**
  String get login_error_wrong_credentials;

  /// No description provided for @login_error_auth_error.
  ///
  /// In en, this message translates to:
  /// **'Authentication error'**
  String get login_error_auth_error;

  /// No description provided for @login_error_invalid_email.
  ///
  /// In en, this message translates to:
  /// **'The email address you entered appears to be invalid. Please check it and try again!'**
  String get login_error_invalid_email;

  /// No description provided for @login_view_prompt.
  ///
  /// In en, this message translates to:
  /// **'Please log in to your account in order to interact with and create notes!'**
  String get login_view_prompt;

  /// No description provided for @login_view_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'I forgot my password'**
  String get login_view_forgot_password;

  /// No description provided for @login_view_not_registered_yet.
  ///
  /// In en, this message translates to:
  /// **'Not registered yet? Register here!'**
  String get login_view_not_registered_yet;

  /// No description provided for @email_text_field_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your email here'**
  String get email_text_field_placeholder;

  /// No description provided for @password_text_field_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your password here'**
  String get password_text_field_placeholder;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgot_password;

  /// No description provided for @forgot_password_view_generic_error.
  ///
  /// In en, this message translates to:
  /// **'We could not process your request. Please make sure that you are a registered user, or if not, register a user now by going back one step.'**
  String get forgot_password_view_generic_error;

  /// No description provided for @forgot_password_view_prompt.
  ///
  /// In en, this message translates to:
  /// **'If you forgot your password, simply enter your email and we will send you a password reset link.'**
  String get forgot_password_view_prompt;

  /// No description provided for @forgot_password_view_send_me_link.
  ///
  /// In en, this message translates to:
  /// **'Send me password reset link'**
  String get forgot_password_view_send_me_link;

  /// No description provided for @forgot_password_view_back_to_login.
  ///
  /// In en, this message translates to:
  /// **'Back to login page'**
  String get forgot_password_view_back_to_login;

  /// No description provided for @register_error_weak_password.
  ///
  /// In en, this message translates to:
  /// **'This password is not secure enough. Please choose another password!'**
  String get register_error_weak_password;

  /// No description provided for @register_error_email_already_in_use.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered to another user. Please choose another email!'**
  String get register_error_email_already_in_use;

  /// No description provided for @register_error_generic.
  ///
  /// In en, this message translates to:
  /// **'Failed to register. Please try again later!'**
  String get register_error_generic;

  /// No description provided for @register_error_invalid_email.
  ///
  /// In en, this message translates to:
  /// **'The email address you entered appears to be invalid. Please try another email address!'**
  String get register_error_invalid_email;

  /// No description provided for @register_view_prompt.
  ///
  /// In en, this message translates to:
  /// **'Register now with your email and password to create your notes!'**
  String get register_view_prompt;

  /// No description provided for @register_view_already_registered.
  ///
  /// In en, this message translates to:
  /// **'Already registered? Login here!'**
  String get register_view_already_registered;

  /// No description provided for @verify_email_view_prompt.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent you an email verification. Please open it to verify your account. If you haven\'t received a verification email yet, press the button below!'**
  String get verify_email_view_prompt;

  /// No description provided for @verify_email_send_email_verification.
  ///
  /// In en, this message translates to:
  /// **'Send email verification'**
  String get verify_email_send_email_verification;

  /// No description provided for @notes_title.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No notes yet} =1{1 note} other{{count} notes}}'**
  String notes_title(num count);
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return L10nEn();
    case 'pt': return L10nPt();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('te'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pashumitra'**
  String get appTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pashumitra'**
  String get welcomeMessage;

  /// No description provided for @appSlogan.
  ///
  /// In en, this message translates to:
  /// **'Your personal AI assistant for modern farming.'**
  String get appSlogan;

  /// No description provided for @getStartedButton.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get Started'**
  String get getStartedButton;

  /// No description provided for @homePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Home Page'**
  String get homePageTitle;

  /// No description provided for @herdPageTitle.
  ///
  /// In en, this message translates to:
  /// **'My Herd Page'**
  String get herdPageTitle;

  /// No description provided for @aiChatPageTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Chat Page'**
  String get aiChatPageTitle;

  /// No description provided for @profilePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Page'**
  String get profilePageTitle;

  /// No description provided for @weatherBoxTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Weather'**
  String get weatherBoxTitle;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @manageFarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Animal Recognition'**
  String get manageFarmTitle;

  /// No description provided for @takeAPicture.
  ///
  /// In en, this message translates to:
  /// **'Take a picture'**
  String get takeAPicture;

  /// No description provided for @breedIdentification.
  ///
  /// In en, this message translates to:
  /// **'Breed Identification'**
  String get breedIdentification;

  /// No description provided for @getAdvice.
  ///
  /// In en, this message translates to:
  /// **'Get Advice'**
  String get getAdvice;

  /// No description provided for @takePictureButton.
  ///
  /// In en, this message translates to:
  /// **'Take a Picture of the Animal'**
  String get takePictureButton;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHerd.
  ///
  /// In en, this message translates to:
  /// **'Herd'**
  String get navHerd;

  /// No description provided for @navAiChat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get navAiChat;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @emergencyMessage.
  ///
  /// In en, this message translates to:
  /// **'Animal Emergency? Call Our helpline for immediate help. If an animal is injured, Stay eith it until help arrives. Emergency Number :📞 9820122602'**
  String get emergencyMessage;

  /// No description provided for @litresPerDay.
  ///
  /// In en, this message translates to:
  /// **'Litres/day'**
  String get litresPerDay;

  /// No description provided for @animalNameLakshmi.
  ///
  /// In en, this message translates to:
  /// **'Lakshmi'**
  String get animalNameLakshmi;

  /// No description provided for @animalBreedHolsteinFriesian.
  ///
  /// In en, this message translates to:
  /// **'Holstein Friesian'**
  String get animalBreedHolsteinFriesian;

  /// No description provided for @animalMilkLakshmi.
  ///
  /// In en, this message translates to:
  /// **'25.5'**
  String get animalMilkLakshmi;

  /// No description provided for @animalNameGanga.
  ///
  /// In en, this message translates to:
  /// **'Ganga'**
  String get animalNameGanga;

  /// No description provided for @animalBreedJersey.
  ///
  /// In en, this message translates to:
  /// **'Jersey'**
  String get animalBreedJersey;

  /// No description provided for @animalMilkGanga.
  ///
  /// In en, this message translates to:
  /// **'22.0'**
  String get animalMilkGanga;

  /// No description provided for @animalNameYamuna.
  ///
  /// In en, this message translates to:
  /// **'Yamuna'**
  String get animalNameYamuna;

  /// No description provided for @animalBreedMurrahBuffalo.
  ///
  /// In en, this message translates to:
  /// **'Murrah Buffalo'**
  String get animalBreedMurrahBuffalo;

  /// No description provided for @animalMilkYamuna.
  ///
  /// In en, this message translates to:
  /// **'18.7'**
  String get animalMilkYamuna;

  /// No description provided for @profileView.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get profileView;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @querySupport.
  ///
  /// In en, this message translates to:
  /// **'Query Support'**
  String get querySupport;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @loggedOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Account'**
  String get loggedOutTitle;

  /// No description provided for @loggedOutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to access your farm details, herd management, and personalized advice.'**
  String get loggedOutSubtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @myProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfileTitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editProfile;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveProfile;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileNameLabel;

  /// No description provided for @profileAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get profileAgeLabel;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get profilePhoneLabel;

  /// No description provided for @chatWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello! I am Pashumitra, your AI assistant. How can I help you with your livestock today?'**
  String get chatWelcomeMessage;

  /// No description provided for @chatError.
  ///
  /// In en, this message translates to:
  /// **'Sorry, an error occurred. Please try again.'**
  String get chatError;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @vaccinationReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Reminder'**
  String get vaccinationReminderTitle;

  /// No description provided for @vaccinationReminderMsg.
  ///
  /// In en, this message translates to:
  /// **'Your cow, Lakshmi, is due for her annual vaccination on October 5th.'**
  String get vaccinationReminderMsg;

  /// No description provided for @healthCheckupTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Checkup'**
  String get healthCheckupTitle;

  /// No description provided for @healthCheckupMsg.
  ///
  /// In en, this message translates to:
  /// **'Schedule a health checkup for your goat. It has been 6 months since the last one.'**
  String get healthCheckupMsg;

  /// No description provided for @newArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'New Article Available'**
  String get newArticleTitle;

  /// No description provided for @newArticleMsg.
  ///
  /// In en, this message translates to:
  /// **'Read our latest article: \"Tips for managing livestock during the winter season.\"'**
  String get newArticleMsg;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

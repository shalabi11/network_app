class AppLocalizations {
  final String languageCode;

  AppLocalizations(this.languageCode);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App
      'app_name': 'Network App',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'cancel': 'Cancel',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'search': 'Search',
      'filter': 'Filter',
      'refresh': 'Refresh',

      // Navigation
      'map': 'Map',
      'list': 'List',
      'settings': 'Settings',

      // Map View
      'map_view_title': 'Cellular Towers Map',
      'my_location': 'My Location',
      'tower_accessible': 'Accessible Tower',
      'tower_not_accessible': 'Not Accessible Tower',
      'tower_details': 'Tower Details',
      'show_details': 'Show Details',
      'hide_details': 'Hide Details',

      // List View
      'list_view_title': 'Towers List',
      'no_towers': 'No towers found',
      'tower_name': 'Tower Name',
      'tower_distance': 'Distance',
      'tower_signal': 'Signal Strength',
      'tower_status': 'Status',
      'ping_tower': 'Ping Tower',
      'pinging': 'Pinging...',

      // Tower Status
      'accessible': 'Accessible',
      'not_accessible': 'Not Accessible',
      'unknown': 'Unknown',
      'online': 'Online',
      'offline': 'Offline',

      // Signal Strength
      'excellent': 'Excellent',
      'good': 'Good',
      'fair': 'Fair',
      'weak': 'Weak',
      'very_weak': 'Very Weak',

      // Settings
      'settings_title': 'Settings',
      'theme_settings': 'Theme Settings',
      'language_settings': 'Language Settings',
      'notification_settings': 'Notification Settings',
      'theme_mode': 'Theme Mode',
      'light_theme': 'Light',
      'dark_theme': 'Dark',
      'system_theme': 'System',
      'language': 'Language',
      'english': 'English',
      'arabic': 'Arabic',
      'notifications': 'Notifications',
      'enable_notifications': 'Enable Notifications',
      'background_updates': 'Background Updates',
      'about': 'About',
      'version': 'Version',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',

      // Network Stats
      'network_stats': 'Network Statistics',
      'signal_strength': 'Signal Strength',
      'ping_latency': 'Ping Latency',
      'upload_speed': 'Upload Speed',
      'download_speed': 'Download Speed',
      'connection_quality': 'Connection Quality',
      'ms': 'ms',
      'mbps': 'Mbps',
      'dbm': 'dBm',

      // Permissions
      'permission_required': 'Permission Required',
      'location_permission':
          'Location permission is required to show nearby towers',
      'notification_permission':
          'Notification permission is required for alerts',
      'grant_permission': 'Grant Permission',
      'permission_denied': 'Permission Denied',

      // Errors
      'error_occurred': 'An error occurred',
      'network_error': 'Network error. Please check your connection',
      'location_error': 'Unable to get your location',
      'no_internet': 'No internet connection',
      'server_error': 'Server error. Please try again later',
      'cache_error': 'Cache error occurred',

      // Onboarding
      'onboarding_title_1': 'Welcome to Network App',
      'onboarding_desc_1':
          'Monitor cellular towers and network performance in real-time',
      'onboarding_title_2': 'View Towers on Map',
      'onboarding_desc_2':
          'See nearby cellular towers with accessibility status',
      'onboarding_title_3': 'Track Network Stats',
      'onboarding_desc_3':
          'Monitor signal strength, ping, and connection quality',
      'skip': 'Skip',
      'next': 'Next',
      'get_started': 'Get Started',
    },
    'ar': {
      // App
      'app_name': 'تطبيق الشبكة',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'retry': 'إعادة المحاولة',
      'cancel': 'إلغاء',
      'ok': 'موافق',
      'yes': 'نعم',
      'no': 'لا',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'search': 'بحث',
      'filter': 'تصفية',
      'refresh': 'تحديث',

      // Navigation
      'map': 'الخريطة',
      'list': 'القائمة',
      'settings': 'الإعدادات',

      // Map View
      'map_view_title': 'خريطة الأبراج الخلوية',
      'my_location': 'موقعي',
      'tower_accessible': 'برج متاح',
      'tower_not_accessible': 'برج غير متاح',
      'tower_details': 'تفاصيل البرج',
      'show_details': 'عرض التفاصيل',
      'hide_details': 'إخفاء التفاصيل',

      // List View
      'list_view_title': 'قائمة الأبراج',
      'no_towers': 'لا توجد أبراج',
      'tower_name': 'اسم البرج',
      'tower_distance': 'المسافة',
      'tower_signal': 'قوة الإشارة',
      'tower_status': 'الحالة',
      'ping_tower': 'فحص البرج',
      'pinging': 'جاري الفحص...',

      // Tower Status
      'accessible': 'متاح',
      'not_accessible': 'غير متاح',
      'unknown': 'غير معروف',
      'online': 'متصل',
      'offline': 'غير متصل',

      // Signal Strength
      'excellent': 'ممتازة',
      'good': 'جيدة',
      'fair': 'متوسطة',
      'weak': 'ضعيفة',
      'very_weak': 'ضعيفة جداً',

      // Settings
      'settings_title': 'الإعدادات',
      'theme_settings': 'إعدادات المظهر',
      'language_settings': 'إعدادات اللغة',
      'notification_settings': 'إعدادات الإشعارات',
      'theme_mode': 'وضع المظهر',
      'light_theme': 'فاتح',
      'dark_theme': 'داكن',
      'system_theme': 'النظام',
      'language': 'اللغة',
      'english': 'الإنجليزية',
      'arabic': 'العربية',
      'notifications': 'الإشعارات',
      'enable_notifications': 'تفعيل الإشعارات',
      'background_updates': 'التحديثات الخلفية',
      'about': 'حول',
      'version': 'الإصدار',
      'privacy_policy': 'سياسة الخصوصية',
      'terms_of_service': 'شروط الخدمة',

      // Network Stats
      'network_stats': 'إحصائيات الشبكة',
      'signal_strength': 'قوة الإشارة',
      'ping_latency': 'زمن الاستجابة',
      'upload_speed': 'سرعة الرفع',
      'download_speed': 'سرعة التنزيل',
      'connection_quality': 'جودة الاتصال',
      'ms': 'مللي ثانية',
      'mbps': 'ميجابت/ثانية',
      'dbm': 'ديسيبل',

      // Permissions
      'permission_required': 'يتطلب إذن',
      'location_permission': 'يتطلب إذن الموقع لعرض الأبراج القريبة',
      'notification_permission': 'يتطلب إذن الإشعارات للتنبيهات',
      'grant_permission': 'منح الإذن',
      'permission_denied': 'تم رفض الإذن',

      // Errors
      'error_occurred': 'حدث خطأ',
      'network_error': 'خطأ في الشبكة. يرجى التحقق من الاتصال',
      'location_error': 'تعذر الحصول على موقعك',
      'no_internet': 'لا يوجد اتصال بالإنترنت',
      'server_error': 'خطأ في الخادم. يرجى المحاولة لاحقاً',
      'cache_error': 'حدث خطأ في التخزين المؤقت',

      // Onboarding
      'onboarding_title_1': 'مرحباً بك في تطبيق الشبكة',
      'onboarding_desc_1': 'راقب الأبراج الخلوية وأداء الشبكة في الوقت الفعلي',
      'onboarding_title_2': 'عرض الأبراج على الخريطة',
      'onboarding_desc_2': 'شاهد الأبراج الخلوية القريبة مع حالة الوصول',
      'onboarding_title_3': 'تتبع إحصائيات الشبكة',
      'onboarding_desc_3': 'راقب قوة الإشارة والاستجابة وجودة الاتصال',
      'skip': 'تخطي',
      'next': 'التالي',
      'get_started': 'ابدأ الآن',
    },
  };

  String translate(String key) {
    return _localizedValues[languageCode]?[key] ?? key;
  }

  String get appName => translate('app_name');
  String get loading => translate('loading');
  String get error => translate('error');
  String get retry => translate('retry');
  String get cancel => translate('cancel');
  String get ok => translate('ok');
  String get yes => translate('yes');
  String get no => translate('no');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get search => translate('search');
  String get filter => translate('filter');
  String get refresh => translate('refresh');

  // Navigation
  String get map => translate('map');
  String get list => translate('list');
  String get settings => translate('settings');

  // Map View
  String get mapViewTitle => translate('map_view_title');
  String get myLocation => translate('my_location');
  String get towerAccessible => translate('tower_accessible');
  String get towerNotAccessible => translate('tower_not_accessible');
  String get towerDetails => translate('tower_details');
  String get showDetails => translate('show_details');
  String get hideDetails => translate('hide_details');

  // List View
  String get listViewTitle => translate('list_view_title');
  String get noTowers => translate('no_towers');
  String get towerName => translate('tower_name');
  String get towerDistance => translate('tower_distance');
  String get towerSignal => translate('tower_signal');
  String get towerStatus => translate('tower_status');
  String get pingTower => translate('ping_tower');
  String get pinging => translate('pinging');

  // Tower Status
  String get accessible => translate('accessible');
  String get notAccessible => translate('not_accessible');
  String get unknown => translate('unknown');
  String get online => translate('online');
  String get offline => translate('offline');

  // Signal Strength
  String get excellent => translate('excellent');
  String get good => translate('good');
  String get fair => translate('fair');
  String get weak => translate('weak');
  String get veryWeak => translate('very_weak');

  // Settings
  String get settingsTitle => translate('settings_title');
  String get themeSettings => translate('theme_settings');
  String get languageSettings => translate('language_settings');
  String get notificationSettings => translate('notification_settings');
  String get themeMode => translate('theme_mode');
  String get lightTheme => translate('light_theme');
  String get darkTheme => translate('dark_theme');
  String get systemTheme => translate('system_theme');
  String get language => translate('language');
  String get english => translate('english');
  String get arabic => translate('arabic');
  String get notifications => translate('notifications');
  String get enableNotifications => translate('enable_notifications');
  String get backgroundUpdates => translate('background_updates');
  String get about => translate('about');
  String get version => translate('version');
  String get privacyPolicy => translate('privacy_policy');
  String get termsOfService => translate('terms_of_service');

  // Network Stats
  String get networkStats => translate('network_stats');
  String get signalStrength => translate('signal_strength');
  String get pingLatency => translate('ping_latency');
  String get uploadSpeed => translate('upload_speed');
  String get downloadSpeed => translate('download_speed');
  String get connectionQuality => translate('connection_quality');
  String get ms => translate('ms');
  String get mbps => translate('mbps');
  String get dbm => translate('dbm');

  // Permissions
  String get permissionRequired => translate('permission_required');
  String get locationPermission => translate('location_permission');
  String get notificationPermission => translate('notification_permission');
  String get grantPermission => translate('grant_permission');
  String get permissionDenied => translate('permission_denied');

  // Errors
  String get errorOccurred => translate('error_occurred');
  String get networkError => translate('network_error');
  String get locationError => translate('location_error');
  String get noInternet => translate('no_internet');
  String get serverError => translate('server_error');
  String get cacheError => translate('cache_error');

  // Onboarding
  String get onboardingTitle1 => translate('onboarding_title_1');
  String get onboardingDesc1 => translate('onboarding_desc_1');
  String get onboardingTitle2 => translate('onboarding_title_2');
  String get onboardingDesc2 => translate('onboarding_desc_2');
  String get onboardingTitle3 => translate('onboarding_title_3');
  String get onboardingDesc3 => translate('onboarding_desc_3');
  String get skip => translate('skip');
  String get next => translate('next');
  String get getStarted => translate('get_started');
}

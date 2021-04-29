part of flutter_parse_sdk;

/// Singleton class that defines all user keys and data
class ParseCoreData {
  factory ParseCoreData() => _instance;

  ParseCoreData._init(this.applicationId, this.serverUrl);

  static late ParseCoreData _instance;

  static ParseCoreData get instance => _instance;

  /// Creates an instance of Parse Server
  ///
  /// This class should not be user unless switching servers during the app,
  /// which is odd. Should only be user by Parse.init
  static Future<void> init(
    String appId,
    String serverUrl, {
    required bool debug,
    String? appName,
    String? appVersion,
    String? appPackageName,
    String? locale,
    String? liveQueryUrl,
    String? masterKey,
    String? clientKey,
    String? sessionId,
    required bool autoSendSessionId,
    SecurityContext? securityContext,
    CoreStore? store,
    Map<String, ParseObjectConstructor>? registeredSubClassMap,
    ParseUserConstructor? parseUserConstructor,
    ParseFileConstructor? parseFileConstructor,
    List<int>? liveListRetryIntervals,
    ParseConnectivityProvider? connectivityProvider,
    String? fileDirectory,
    Stream<void>? appResumedStream,
    ParseClientCreator? clientCreator,
  }) async {
    _instance = ParseCoreData._init(appId, serverUrl);

    _instance.storage = store ?? CoreStoreMemoryImp();
    _instance.debug = debug;
    _instance.appName = appName;
    _instance.appVersion = appVersion;
    _instance.appPackageName = appPackageName;
    _instance.locale = locale;
    _instance.liveQueryURL = liveQueryUrl;
    _instance.clientKey = clientKey;
    _instance.masterKey = masterKey;
    _instance.sessionId = sessionId;
    _instance.autoSendSessionId = autoSendSessionId;
    _instance.securityContext = securityContext;
    _instance.liveListRetryIntervals = liveListRetryIntervals ??
        (parseIsWeb
            ? <int>[0, 500, 1000, 2000, 5000]
            : <int>[0, 500, 1000, 2000, 5000, 10000]);
    _instance._subClassHandler = ParseSubClassHandler(
      registeredSubClassMap: registeredSubClassMap,
      parseUserConstructor: parseUserConstructor,
      parseFileConstructor: parseFileConstructor,
    );
    _instance.connectivityProvider = connectivityProvider;
    _instance.fileDirectory = fileDirectory;
    _instance.appResumedStream = appResumedStream;
    _instance.clientCreator = clientCreator ??
        (({required bool sendSessionId, SecurityContext? securityContext}) =>
            ParseHTTPClient(
                sendSessionId: sendSessionId, securityContext: securityContext));
  }

  String applicationId;
  String serverUrl;
  String? appName;
  String? appVersion;
  String? appPackageName;
  String? locale;
  String? liveQueryURL;
  String? masterKey;
  String? clientKey;
  String? sessionId;
  late bool autoSendSessionId;
  SecurityContext? securityContext;
  late bool debug;
  late CoreStore storage;
  late ParseSubClassHandler _subClassHandler;
  late List<int> liveListRetryIntervals;
  ParseConnectivityProvider? connectivityProvider;
  String? fileDirectory;
  Stream<void>? appResumedStream;
  late ParseClientCreator clientCreator;

  void registerSubClass(
      String className, ParseObjectConstructor objectConstructor) {
    _subClassHandler.registerSubClass(className, objectConstructor);
  }

  void registerUserSubClass(ParseUserConstructor parseUserConstructor) {
    _subClassHandler.registerUserSubClass(parseUserConstructor);
  }

  void registerFileSubClass(ParseFileConstructor parseFileConstructor) {
    _subClassHandler.registerFileSubClass(parseFileConstructor);
  }

  ParseObject createObject(String classname) {
    return _subClassHandler.createObject(classname);
  }

  ParseUser createParseUser(
      String? username, String? password, String? emailAddress,
      {String? sessionToken, bool? debug, ParseClient? client}) {
    return _subClassHandler.createParseUser(username, password, emailAddress,
        sessionToken: sessionToken, debug: debug, client: client);
  }

  ParseFileBase createFile({String? url, String? name}) =>
      _subClassHandler.createFile(name: name, url: url);

  /// Sets the current sessionId.
  ///
  /// This is generated when a users logs in, or calls currentUser to update
  /// their keys
  void setSessionId(String sessionId) {
    this.sessionId = sessionId;
  }

  CoreStore getStore() {
    return storage;
  }

  @override
  String toString() => '$applicationId $masterKey';

  static void setFromMap(dynamic message) {
    if (message == null) {
      throw ArgumentError('The parameter \'message\' should not be null.');
    }

    final Map<dynamic, dynamic> coreDataMap = message;
    final appId = coreDataMap['applicationId'] ?? '';
    final serverUrl = coreDataMap['serverUrl'] ?? '';
    final ParseCoreData coreData = ParseCoreData._init(appId, serverUrl);
    coreData.appName = coreDataMap['name'];
    coreData.appVersion = coreDataMap['appVersion'];
    coreData.appPackageName = coreDataMap['appPackageName'];
    coreData.locale = coreDataMap['locale'];
    coreData.liveQueryURL = coreDataMap['liveQueryURL'];
    coreData.masterKey = coreDataMap['masterKey'];
    coreData.clientKey = coreDataMap['clientKey'];
    coreData.sessionId = coreDataMap['sessionId'];
    coreData.autoSendSessionId = coreDataMap['autoSendSessionId'] ?? true;
    coreData.securityContext = coreDataMap['securityContext'];
    coreData.debug = coreDataMap['debug'] ?? false;
    coreData.liveListRetryIntervals = coreDataMap['liveListRetryIntervals'];
    coreData.fileDirectory = coreDataMap['fileDirectory'];
    coreData._subClassHandler = ParseSubClassHandler(
      registeredSubClassMap: null,
      parseUserConstructor: null,
      parseFileConstructor: null,
    );
    coreData.storage = CoreStoreMemoryImp();
    coreData.clientCreator = (({required bool sendSessionId, SecurityContext? securityContext}) => ParseHTTPClient(sendSessionId: sendSessionId, securityContext: securityContext));
    _instance = coreData;
  }

  /// Converts the [ParseCoreData] instance into a [Map] instance that can be
  /// serialized to JSON.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = Map<String, dynamic>();
    map['appName'] = appName;
    map['appVersion'] = appVersion;
    map['appPackageName'] = appPackageName;
    map['applicationId'] = applicationId;
    map['locale'] = locale;
    map['serverUrl'] = serverUrl;
    map['liveQueryURL'] = liveQueryURL;
    map['masterKey'] = masterKey;
    map['clientKey'] = clientKey;
    map['sessionId'] = sessionId;
    map['autoSendSessionId'] = autoSendSessionId;
    map['securityContext'] = securityContext;
    map['debug'] = debug;
    map['liveListRetryIntervals'] = liveListRetryIntervals;
    map['fileDirectory'] = fileDirectory;
    return map;
  }
}

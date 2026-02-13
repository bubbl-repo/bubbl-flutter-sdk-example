import 'dart:async';

import 'package:bubbl_flutter_sdk/bubbl_flutter_sdk.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BubblFlutterExampleApp());
}

class BubblFlutterExampleApp extends StatelessWidget {
  const BubblFlutterExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bubbl Flutter SDK Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F172A)),
        useMaterial3: true,
      ),
      home: const BubblMethodPlaygroundPage(),
    );
  }
}

class BubblMethodPlaygroundPage extends StatefulWidget {
  const BubblMethodPlaygroundPage({super.key});

  @override
  State<BubblMethodPlaygroundPage> createState() =>
      _BubblMethodPlaygroundPageState();
}

class _BubblMethodPlaygroundPageState extends State<BubblMethodPlaygroundPage> {
  final BubblFlutterSdk _sdk = BubblFlutterSdk.instance;

  final TextEditingController _apiKeyController = TextEditingController(
    text: 'REPLACE_WITH_API_KEY',
  );
  final TextEditingController _segmentsController = TextEditingController(
    text: 'vip,early_access',
  );
  final TextEditingController _correlationController = TextEditingController(
    text: 'flutter-user-123',
  );
  final TextEditingController _latitudeController = TextEditingController(
    text: '6.5244',
  );
  final TextEditingController _longitudeController = TextEditingController(
    text: '3.3792',
  );
  final TextEditingController _notificationIdController = TextEditingController(
    text: '101',
  );
  final TextEditingController _locationIdController = TextEditingController(
    text: 'demo-location-1',
  );

  BubblEnvironment _environment = BubblEnvironment.staging;
  List<String> _logs = <String>[];

  StreamSubscription<Map<String, dynamic>>? _notificationSubscription;
  StreamSubscription<Map<String, dynamic>>? _geofenceSubscription;
  StreamSubscription<Map<String, dynamic>>? _deviceLogSubscription;

  @override
  void initState() {
    super.initState();

    _notificationSubscription = _sdk.notificationEvents().listen((event) {
      _appendLog('event:notificationEvents => $event');
    });

    _geofenceSubscription = _sdk.geofenceEvents().listen((event) {
      _appendLog('event:geofenceEvents => $event');
    });

    _deviceLogSubscription = _sdk.deviceLogEvents().listen((event) {
      _appendLog('event:deviceLogEvents => $event');
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    _geofenceSubscription?.cancel();
    _deviceLogSubscription?.cancel();

    _apiKeyController.dispose();
    _segmentsController.dispose();
    _correlationController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _notificationIdController.dispose();
    _locationIdController.dispose();

    super.dispose();
  }

  void _appendLog(String message) {
    final String entry = '${DateTime.now().toIso8601String()} $message';
    setState(() {
      _logs = <String>[entry, ..._logs].take(140).toList();
    });
  }

  Future<void> _runAction(
    String name,
    Future<dynamic> Function() action,
  ) async {
    try {
      final dynamic value = await action();
      _appendLog('$name => $value');
    } catch (error) {
      _appendLog('$name failed => $error');
    }
  }

  List<String> get _segments {
    return _segmentsController.text
        .split(',')
        .map((String token) => token.trim())
        .where((String token) => token.isNotEmpty)
        .toList();
  }

  double get _latitude {
    return double.tryParse(_latitudeController.text.trim()) ?? 0;
  }

  double get _longitude {
    return double.tryParse(_longitudeController.text.trim()) ?? 0;
  }

  int get _notificationId {
    return int.tryParse(_notificationIdController.text.trim()) ?? 0;
  }

  String get _notificationIdAsString {
    return _notificationIdController.text.trim().isEmpty
        ? '0'
        : _notificationIdController.text.trim();
  }

  String get _locationId {
    return _locationIdController.text.trim().isEmpty
        ? 'demo-location-1'
        : _locationIdController.text.trim();
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }

  Widget _actionButton(String label, Future<void> Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: onPressed, child: Text(label)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bubbl Flutter SDK Example'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Method playground aligned with guides/flutter-sdk/method-reference.md',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              _sectionTitle('Setup'),
              TextField(
                controller: _apiKeyController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'API Key',
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<BubblEnvironment>(
                value: _environment,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Environment',
                ),
                items: BubblEnvironment.values
                    .map(
                      (BubblEnvironment value) => DropdownMenuItem<BubblEnvironment>(
                        value: value,
                        child: Text(value.name),
                      ),
                    )
                    .toList(),
                onChanged: (BubblEnvironment? value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _environment = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _segmentsController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Segments (comma separated)',
                ),
              ),
              const SizedBox(height: 8),
              _actionButton(
                'init({apiKey, options})',
                () => _runAction(
                  'init',
                  () => _sdk.init(
                    apiKey: _apiKeyController.text.trim(),
                    options: BubblBootOptions(
                      environment: _environment,
                      segmentationTags: _segments,
                      geoPollIntervalMs: 300000,
                      defaultDistance: 25,
                    ),
                  ),
                ),
              ),
              _actionButton(
                'boot({apiKey, options})',
                () => _runAction(
                  'boot',
                  () => _sdk.boot(
                    apiKey: _apiKeyController.text.trim(),
                    options: BubblBootOptions(
                      environment: _environment,
                      segmentationTags: _segments,
                      geoPollIntervalMs: 300000,
                      defaultDistance: 25,
                    ),
                  ),
                ),
              ),
              _actionButton(
                'requiredPermissions()',
                () => _runAction('requiredPermissions', _sdk.requiredPermissions),
              ),
              _actionButton(
                'locationGranted()',
                () => _runAction('locationGranted', _sdk.locationGranted),
              ),
              _actionButton(
                'notificationGranted()',
                () => _runAction('notificationGranted', _sdk.notificationGranted),
              ),
              _actionButton(
                'requestPushPermission()',
                () => _runAction('requestPushPermission', _sdk.requestPushPermission),
              ),
              _actionButton(
                'startLocationTracking()',
                () => _runAction('startLocationTracking', _sdk.startLocationTracking),
              ),

              _sectionTitle('Location and Campaigns'),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _latitudeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Latitude',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _longitudeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Longitude',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _actionButton(
                'refreshGeofence({latitude, longitude})',
                () => _runAction(
                  'refreshGeofence',
                  () => _sdk.refreshGeofence(
                    latitude: _latitude,
                    longitude: _longitude,
                  ),
                ),
              ),
              _actionButton(
                'hasCampaigns()',
                () => _runAction('hasCampaigns', _sdk.hasCampaigns),
              ),
              _actionButton(
                'getCampaignCount()',
                () => _runAction('getCampaignCount', _sdk.getCampaignCount),
              ),
              _actionButton(
                'forceRefreshCampaigns()',
                () => _runAction('forceRefreshCampaigns', _sdk.forceRefreshCampaigns),
              ),
              _actionButton(
                'clearCachedCampaigns()',
                () => _runAction('clearCachedCampaigns', _sdk.clearCachedCampaigns),
              ),

              _sectionTitle('Segmentation and Config'),
              TextField(
                controller: _correlationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correlation ID',
                ),
              ),
              const SizedBox(height: 8),
              _actionButton(
                'updateSegments(tags)',
                () => _runAction('updateSegments', () => _sdk.updateSegments(_segments)),
              ),
              _actionButton(
                'setCorrelationId(correlationId)',
                () => _runAction(
                  'setCorrelationId',
                  () => _sdk.setCorrelationId(_correlationController.text.trim()),
                ),
              ),
              _actionButton(
                'getCorrelationId()',
                () => _runAction('getCorrelationId', _sdk.getCorrelationId),
              ),
              _actionButton(
                'clearCorrelationId()',
                () => _runAction('clearCorrelationId', _sdk.clearCorrelationId),
              ),
              _actionButton(
                'getCurrentConfiguration()',
                () => _runAction('getCurrentConfiguration', _sdk.getCurrentConfiguration),
              ),
              _actionButton(
                'getPrivacyText()',
                () => _runAction('getPrivacyText', _sdk.getPrivacyText),
              ),
              _actionButton(
                'refreshPrivacyText()',
                () => _runAction('refreshPrivacyText', _sdk.refreshPrivacyText),
              ),

              _sectionTitle('Events and Surveys'),
              TextField(
                controller: _notificationIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Notification ID',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _locationIdController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Location ID',
                ),
              ),
              const SizedBox(height: 8),
              _actionButton(
                'sendEvent(params)',
                () => _runAction(
                  'sendEvent',
                  () => _sdk.sendEvent(
                    BubblSendEventParams(
                      curatedNotificationId: _notificationIdAsString,
                      locationId: _locationId,
                      type: 'notification',
                      activity: 'notification_delivered',
                      latitude: _latitude,
                      longitude: _longitude,
                    ),
                  ),
                ),
              ),
              _actionButton(
                'cta({notificationId, locationId})',
                () => _runAction(
                  'cta',
                  () => _sdk.cta(
                    notificationId: _notificationId,
                    locationId: _locationId,
                  ),
                ),
              ),
              _actionButton(
                'trackSurveyEvent({notificationId, locationId, activity})',
                () => _runAction(
                  'trackSurveyEvent',
                  () => _sdk.trackSurveyEvent(
                    notificationId: _notificationIdAsString,
                    locationId: _locationId,
                    activity: 'notification_opened',
                  ),
                ),
              ),
              _actionButton(
                'submitSurveyResponse({notificationId, locationId, answers})',
                () => _runAction(
                  'submitSurveyResponse',
                  () => _sdk.submitSurveyResponse(
                    notificationId: _notificationIdAsString,
                    locationId: _locationId,
                    answers: const <BubblSurveyAnswer>[
                      BubblSurveyAnswer(
                        questionId: 1,
                        type: 'RATING',
                        value: '5',
                      ),
                      BubblSurveyAnswer(
                        questionId: 2,
                        type: 'MULTIPLE_CHOICE',
                        value: 'YES',
                        choice: <BubblChoiceSelection>[
                          BubblChoiceSelection(choiceId: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              _sectionTitle('Tenant and Diagnostics'),
              _actionButton(
                'getTenantConfig()',
                () => _runAction('getTenantConfig', _sdk.getTenantConfig),
              ),
              _actionButton(
                'setTenantConfig({apiKey, environment})',
                () => _runAction(
                  'setTenantConfig',
                  () => _sdk.setTenantConfig(
                    apiKey: _apiKeyController.text.trim(),
                    environment: _environment,
                  ),
                ),
              ),
              _actionButton(
                'clearTenantConfig()',
                () => _runAction('clearTenantConfig', _sdk.clearTenantConfig),
              ),
              _actionButton(
                'clearStoredConfig()',
                () => _runAction('clearStoredConfig', _sdk.clearStoredConfig),
              ),
              _actionButton(
                'getDeviceLogStreamInfo()',
                () => _runAction('getDeviceLogStreamInfo', _sdk.getDeviceLogStreamInfo),
              ),
              _actionButton(
                'getDeviceLogTail({maxLines})',
                () => _runAction(
                  'getDeviceLogTail',
                  () => _sdk.getDeviceLogTail(maxLines: 40),
                ),
              ),
              _actionButton(
                'startDeviceLogStream({options})',
                () => _runAction(
                  'startDeviceLogStream',
                  () => _sdk.startDeviceLogStream(
                    options: const BubblDeviceLogStreamOptions(
                      intervalMs: 2500,
                      maxLines: 40,
                    ),
                  ),
                ),
              ),
              _actionButton(
                'stopDeviceLogStream()',
                () => _runAction('stopDeviceLogStream', _sdk.stopDeviceLogStream),
              ),
              _actionButton(
                'getApiKey()',
                () => _runAction('getApiKey', _sdk.getApiKey),
              ),
              _actionButton(
                'sayHello()',
                () => _runAction('sayHello', _sdk.sayHello),
              ),
              _actionButton(
                'testNotification()',
                () => _runAction('testNotification', _sdk.testNotification),
              ),

              _sectionTitle('Log'),
              if (_logs.isEmpty)
                const Text('No actions yet.')
              else
                ..._logs.map(
                  (String line) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(line, style: const TextStyle(fontSize: 12)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

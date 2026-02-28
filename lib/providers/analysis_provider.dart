import 'package:flutter/foundation.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../models/analysis_result.dart';
import '../services/api_service.dart';

enum AnalysisState { idle, loading, success, error }

class AnalysisProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  AnalysisState _state = AnalysisState.idle;
  AnalysisResult? _result;
  String? _errorMessage;
  final List<AnalysisResult> _history = [];
  bool _historyLoaded = false;
  bool _historyLoading = false;

  AnalysisState get state => _state;
  AnalysisResult? get result => _result;
  String? get errorMessage => _errorMessage;
  List<AnalysisResult> get history => _history;
  bool get historyLoading => _historyLoading;

  Future<void> analyzeContract({
    required String contractText,
    String? agreementType,
  }) async {
    _state = AnalysisState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _result = await _apiService.analyzeContract(
        contractText: contractText,
        agreementType: agreementType,
      );
      _history.insert(0, _result!);
      _state = AnalysisState.success;
      FirebaseAnalytics.instance.logEvent(
        name: 'contract_analyzed',
        parameters: {'agreement_type': _result!.agreementType},
      );
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = AnalysisState.error;
    }
    notifyListeners();
  }

  Future<void> analyzePdf({
    required Uint8List fileBytes,
    String? agreementType,
  }) async {
    _state = AnalysisState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _result = await _apiService.analyzeContractPdf(
        fileBytes: fileBytes,
        agreementType: agreementType,
      );
      _history.insert(0, _result!);
      _state = AnalysisState.success;
      FirebaseAnalytics.instance.logEvent(
        name: 'contract_analyzed',
        parameters: {'agreement_type': _result!.agreementType},
      );
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = AnalysisState.error;
    }
    notifyListeners();
  }

  Future<void> fetchHistory() async {
    if (_historyLoaded || _historyLoading) return;
    _historyLoading = true;
    notifyListeners();

    try {
      final results = await _apiService.fetchHistory();
      _history.clear();
      _history.addAll(results);
      _historyLoaded = true;
    } catch (e) {
      // Silently fail — in-memory history still works
    }
    _historyLoading = false;
    notifyListeners();
  }

  void selectResult(AnalysisResult r) {
    _result = r;
    _state = AnalysisState.success;
    notifyListeners();
  }

  /// Record user decision on the current analysis.
  void setDecision(String analysisId, String decision) {
    if (_result?.id == analysisId) {
      _result!.userDecision = decision;
    }
    for (final r in _history) {
      if (r.id == analysisId) {
        r.userDecision = decision;
        break;
      }
    }
    notifyListeners();
  }

  void reset() {
    _state = AnalysisState.idle;
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }
}

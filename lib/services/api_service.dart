import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/analysis_result.dart';

class ApiService {
  static const String _functionUrl =
      'https://analyzecontract-dkn2ez4iia-uc.a.run.app';
  static const String _historyUrl =
      'https://us-central1-finguard-4dacc.cloudfunctions.net/getHistory';
  static const String _logDecisionUrl =
      'https://us-central1-finguard-4dacc.cloudfunctions.net/logDecision';
  static const String _chatUrl =
      'https://us-central1-finguard-4dacc.cloudfunctions.net/chatWithAgreement';
  static const String _debateAudioUrl =
      'https://us-central1-finguard-4dacc.cloudfunctions.net/generateDebateAudio';

  Future<List<AnalysisResult>> fetchHistory({int limit = 20}) async {
    final response = await http.get(
      Uri.parse('$_historyUrl?limit=$limit'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['success'] == true) {
        final list = json['analyses'] as List<dynamic>;
        return list
            .map((item) =>
                AnalysisResult.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw Exception(json['error'] ?? 'Failed to fetch history');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  Future<AnalysisResult> analyzeContract({
    required String contractText,
    String? agreementType,
  }) async {
    final response = await http.post(
      Uri.parse(_functionUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contract_text': contractText,
        if (agreementType != null) 'agreement_type': agreementType,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['success'] == true) {
        return AnalysisResult.fromJson(json);
      }
      throw Exception(json['error'] ?? 'Analysis failed');
    } else {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(json['message'] ?? 'Server error: ${response.statusCode}');
    }
  }

  /// Log user decision for behavioral impact analytics.
  Future<void> logDecision({
    required String analysisId,
    required String decision,
    required int riskScore,
  }) async {
    await http.post(
      Uri.parse(_logDecisionUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'analysis_id': analysisId,
        'decision': decision,
        'risk_score': riskScore,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      }),
    );
  }

  /// Send a clarification question about the analyzed agreement.
  Future<String> chatWithAgreement({
    required String userMessage,
    required List<Map<String, String>> conversationHistory,
    required Map<String, dynamic> agreementContext,
  }) async {
    final response = await http.post(
      Uri.parse(_chatUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_message': userMessage,
        'conversation_history': conversationHistory,
        'agreement_context': agreementContext,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['success'] == true) {
        return json['reply'] as String;
      }
      throw Exception(json['error'] ?? 'Chat failed');
    } else {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(
          json['message'] ?? 'Server error: ${response.statusCode}');
    }
  }

  /// Generate merged TTS audio for a debate transcript.
  /// Returns { audioUrl, timings, durationMs }.
  Future<Map<String, dynamic>> generateDebateAudio({
    required String analysisId,
    required List<DebateTurn> debateTranscript,
  }) async {
    final response = await http.post(
      Uri.parse(_debateAudioUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'analysis_id': analysisId,
        'debate_transcript': debateTranscript
            .map((t) => {'speaker': t.speaker, 'message': t.message})
            .toList(),
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['success'] == true) {
        return json;
      }
      throw Exception(json['error'] ?? 'Audio generation failed');
    } else {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(
          json['message'] ?? 'Server error: ${response.statusCode}');
    }
  }

  Future<AnalysisResult> analyzeContractPdf({
    required Uint8List fileBytes,
    String? agreementType,
  }) async {
    final response = await http.post(
      Uri.parse(_functionUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'pdf_bytes_base64': base64Encode(fileBytes),
        if (agreementType != null) 'agreement_type': agreementType,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (json['success'] == true) {
        return AnalysisResult.fromJson(json);
      }
      throw Exception(json['error'] ?? 'Analysis failed');
    } else {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(json['message'] ?? 'Server error: ${response.statusCode}');
    }
  }
}

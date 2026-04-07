import 'dart:io';

import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../models/search_history_item.dart';
import '../models/search_response.dart';
import '../services/history_storage_service.dart';
import '../services/question_api_service.dart';

class SearchState extends ChangeNotifier {
  SearchState({
    QuestionApiService? apiService,
    HistoryStorageService? storageService,
  })  : _apiService = apiService ?? QuestionApiService(),
        _storageService = storageService ?? HistoryStorageService();

  static const _historyLimit = 20;

  final QuestionApiService _apiService;
  final HistoryStorageService _storageService;

  bool _isInitialized = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _lastImagePath;
  SearchResponse? _currentResponse;
  List<SearchHistoryItem> _recentSearches = const [];

  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String get backendBaseUrl => AppConfig.backendBaseUrl;
  String? get errorMessage => _errorMessage;
  String? get lastImagePath => _lastImagePath;
  SearchResponse? get currentResponse => _currentResponse;
  List<SearchHistoryItem> get recentSearches => _recentSearches;

  Future<void> initialize() async {
    final loadedHistory = await _storageService.loadHistory(limit: _historyLimit);
    _recentSearches = loadedHistory.take(_historyLimit).toList(growable: false);

    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> searchByImageFile(File imageFile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var isSuccess = false;

    try {
      final response = await _apiService.uploadImage(
        baseUrl: AppConfig.backendBaseUrl,
        imageFile: imageFile,
      );

      _currentResponse = response;
      _lastImagePath = imageFile.path;
      await _storageService.insertHistory(
        SearchHistoryItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
          ocrText: response.ocrText,
          results: response.results,
        ),
      );
      _recentSearches = await _storageService.loadHistory(limit: _historyLimit);
      isSuccess = true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = '上传或识别失败，请稍后重试。';
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return isSuccess;
  }

  void selectHistoryItem(SearchHistoryItem item) {
    _errorMessage = null;
    _currentResponse = SearchResponse(
      ocrText: item.ocrText,
      count: item.results.length,
      results: item.results,
    );
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _recentSearches = const [];
    await _storageService.clearHistory();
    notifyListeners();
  }
}

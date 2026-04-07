import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../state/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.onSearchSuccess,
    required this.onOpenHistory,
  });

  final VoidCallback onSearchSuccess;
  final VoidCallback onOpenHistory;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndSearch(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 95,
        maxWidth: 2800,
      );
      if (picked == null || !mounted) {
        return;
      }

      final cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        compressQuality: 95,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '裁剪题目区域',
            toolbarColor: const Color(0xFF155E75),
            toolbarWidgetColor: Colors.white,
            statusBarLight: false,
            statusBarColor: const Color(0xFF155E75),
            navBarLight: false,
            backgroundColor: const Color(0xFF0B0F14),
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: '裁剪题目区域',
            aspectRatioLockEnabled: false,
            doneButtonTitle: '完成',
            cancelButtonTitle: '取消',
          ),
        ],
      );
      if (cropped == null || !mounted) {
        return;
      }

      final success = await context.read<SearchState>().searchByImageFile(File(cropped.path));
      if (success && mounted) {
        widget.onSearchSuccess();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('图片处理失败：$error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchState>(
      builder: (context, state, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 820 ? 28.0 : 16.0;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 14, horizontalPadding, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 14),
                  _sectionCard(
                    title: '搜题操作',
                    trailing: TextButton.icon(
                      onPressed: widget.onOpenHistory,
                      icon: const Icon(Icons.history),
                      label: const Text('历史记录'),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: state.isLoading ? null : () => _pickAndSearch(ImageSource.camera),
                                icon: const Icon(Icons.camera_alt_outlined),
                                label: const Text('拍照搜题'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: state.isLoading ? null : () => _pickAndSearch(ImageSource.gallery),
                                icon: const Icon(Icons.photo_library_outlined),
                                label: const Text('相册选图'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (state.lastImagePath != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(state.lastImagePath!),
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        else
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            alignment: Alignment.center,
                            child: const Text('尚未选择图片'),
                          ),
                        if (state.isLoading) ...[
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2.4),
                              ),
                              SizedBox(width: 10),
                              Text('正在上传并识别，请稍候...'),
                            ],
                          ),
                        ],
                        if (state.errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            state.errorMessage!,
                            style: const TextStyle(
                              color: Color(0xFFB91C1C),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F766E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '12123学法减分拍照搜题',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '支持拍照或相册选图，先裁剪题目再上传识别，目前，题库尚不完善。',
            style: TextStyle(
              color: Color(0xFFE2F8F3),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Oopie专用',
            style: TextStyle(
              color: Color(0xFFC5F3EA),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

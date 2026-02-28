import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/analysis_provider.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _textController = TextEditingController();
  String _selectedType = 'Auto-detect';
  String? _selectedFileName;
  Uint8List? _selectedFileBytes;

  final _agreementTypes = [
    'Auto-detect',
    'Personal Loan',
    'Guarantor Agreement',
    'Hire Purchase',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFileName = result.files.first.name;
        _selectedFileBytes = result.files.first.bytes;
      });
    }
  }

  void _analyze() {
    final provider = context.read<AnalysisProvider>();
    final type = _selectedType == 'Auto-detect' ? null : _selectedType;

    if (_tabController.index == 0) {
      final text = _textController.text.trim();
      if (text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please paste your contract text'),
            backgroundColor: const Color(0xFF1E1E2E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
      provider.analyzeContract(contractText: text, agreementType: type);
    } else {
      if (_selectedFileName == null || _selectedFileBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select a PDF file'),
            backgroundColor: const Color(0xFF1E1E2E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
      provider.analyzePdf(fileBytes: _selectedFileBytes!, agreementType: type);
    }

    Navigator.pushNamed(context, '/result');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyze Agreement',
            style: TextStyle(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isWide ? 700 : double.infinity),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Agreement type
              const Text('Agreement Type',
                  style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                      fontSize: 13)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedType,
                dropdownColor: const Color(0xFF1E1E2E),
                style: const TextStyle(color: Color(0xFFE2E8F0)),
                items: _agreementTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),

              const SizedBox(height: 24),

              // Tabs
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF12121E),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF2A2A3E)),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF64748B),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit_note_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Paste Text'),
                      ],
                    )),
                    Tab(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Upload PDF'),
                      ],
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Text paste
                    TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(color: Color(0xFFE2E8F0), fontSize: 14, height: 1.6),
                      decoration: InputDecoration(
                        hintText: 'Paste your financial agreement text here...\n\n'
                            'Supported types:\n'
                            '  Personal Loan Agreements\n'
                            '  Guarantor Contracts\n'
                            '  Hire Purchase Agreements',
                        hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 14),
                        filled: true,
                        fillColor: const Color(0xFF0F0F1A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF2A2A3E)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF2A2A3E)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.all(18),
                      ),
                    ),

                    // PDF upload
                    Center(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFF0F0F1A),
                          border: Border.all(
                            color: _selectedFileName != null
                                ? const Color(0xFF8B5CF6).withValues(alpha: 0.5)
                                : const Color(0xFF2A2A3E),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _selectedFileName != null
                                    ? const Color(0xFF8B5CF6).withValues(alpha: 0.15)
                                    : const Color(0xFF1E1E2E),
                              ),
                              child: Icon(
                                _selectedFileName != null
                                    ? Icons.description_rounded
                                    : Icons.cloud_upload_outlined,
                                size: 40,
                                color: _selectedFileName != null
                                    ? const Color(0xFF8B5CF6)
                                    : const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _selectedFileName ?? 'Select a PDF contract file',
                              style: TextStyle(
                                color: _selectedFileName != null
                                    ? const Color(0xFFE2E8F0)
                                    : const Color(0xFF64748B),
                                fontWeight: _selectedFileName != null
                                    ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: _pickPdf,
                              icon: const Icon(Icons.folder_open_rounded),
                              label: Text(_selectedFileName != null ? 'Change File' : 'Browse Files'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFA78BFA),
                                side: const BorderSide(color: Color(0xFF2A2A3E)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Analyze button
              SizedBox(
                height: 54,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _analyze,
                      borderRadius: BorderRadius.circular(14),
                      child: const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.security_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Analyze with FinGuard AI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

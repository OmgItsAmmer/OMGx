import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecommerce_dashboard/services/gemini_service.dart';
import 'package:ecommerce_dashboard/common/widgets/loaders/tloaders.dart';
import 'package:ecommerce_dashboard/utils/constants/colors.dart';
import 'package:ecommerce_dashboard/utils/constants/sizes.dart';

class GeminiApiKeyDialog extends StatefulWidget {
  const GeminiApiKeyDialog({super.key});

  @override
  State<GeminiApiKeyDialog> createState() => _GeminiApiKeyDialogState();
}

class _GeminiApiKeyDialogState extends State<GeminiApiKeyDialog> {
  final TextEditingController _apiKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isKeyConfigured = false;

  @override
  void initState() {
    super.initState();
    _checkApiKeyStatus();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _checkApiKeyStatus() async {
    final isConfigured = await GeminiService.isApiKeyConfigured();
    setState(() {
      _isKeyConfigured = isConfigured;
    });
  }

  Future<void> _saveApiKey() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await GeminiService.setApiKey(_apiKeyController.text.trim());

      setState(() {
        _isKeyConfigured = true;
        _isLoading = false;
      });

      TLoaders.successSnackBar(
        title: "Success",
        message: "Gemini API key configured successfully!",
      );

      Get.back();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      TLoaders.errorSnackBar(
        title: "Error",
        message: "Failed to save API key: ${e.toString()}",
      );
    }
  }

  Future<void> _removeApiKey() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await GeminiService.removeApiKey();

      setState(() {
        _isKeyConfigured = false;
        _isLoading = false;
      });

      TLoaders.successSnackBar(
        title: "Success",
        message: "API key removed successfully!",
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      TLoaders.errorSnackBar(
        title: "Error",
        message: "Failed to remove API key: ${e.toString()}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.auto_awesome, color: TColors.primary),
          const SizedBox(width: TSizes.sm),
          const Text('Gemini AI Configuration'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_isKeyConfigured) ...[
              const Text(
                'To use AI-powered product description generation, you need to configure your Gemini API key.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: TSizes.md),
              const Text(
                'How to get your API key:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: TSizes.xs),
              const Text(
                '1. Go to Google AI Studio (https://makersuite.google.com/app/apikey)\n'
                '2. Create a new API key\n'
                '3. Copy and paste it below',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: TSizes.md),
              TextFormField(
                controller: _apiKeyController,
                decoration: const InputDecoration(
                  labelText: 'Gemini API Key',
                  hintText: 'Enter your Gemini API key',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'API key is required';
                  }
                  if (value.trim().length < 10) {
                    return 'API key seems too short';
                  }
                  return null;
                },
                obscureText: true,
              ),
            ] else ...[
              const Text(
                '✅ Gemini API key is configured and ready to use!',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: TSizes.md),
              const Text(
                'You can now use the AI button in the product description field to generate compelling descriptions.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        if (!_isKeyConfigured)
          ElevatedButton(
            onPressed: _isLoading ? null : _saveApiKey,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        if (_isKeyConfigured)
          TextButton(
            onPressed: _isLoading ? null : _removeApiKey,
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Remove Key'),
          ),
      ],
    );
  }
}

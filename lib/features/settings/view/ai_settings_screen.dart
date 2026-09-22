import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lotus_ai/core/services/ai/ai_provider_registry.dart';
import 'package:lotus_ai/features/settings/entity/app_settings.dart';
import 'package:lotus_ai/features/settings/presenter/settings_bloc.dart';
import 'package:lotus_ai/features/settings/presenter/settings_event.dart';
import 'package:lotus_ai/features/settings/presenter/settings_state.dart';
import 'package:lotus_ai/features/settings/router/settings_router.dart';

class AiSettingsScreen extends StatefulWidget {
  const AiSettingsScreen({required this.router, super.key});

  final SettingsRouter router;

  @override
  State<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends State<AiSettingsScreen> {
  late TextEditingController _geminiKeyCtrl;
  late TextEditingController _grokKeyCtrl;
  late TextEditingController _alibabaKeyCtrl;
  late TextEditingController _ollamaUrlCtrl;
  late TextEditingController _customEndpointCtrl;
  late TextEditingController _customKeyCtrl;
  late TextEditingController _systemPromptCtrl;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsBloc>().state.settings;
    _geminiKeyCtrl = TextEditingController(text: settings.geminiApiKey);
    _grokKeyCtrl = TextEditingController(text: settings.grokApiKey);
    _alibabaKeyCtrl = TextEditingController(text: settings.alibabaApiKey);
    _ollamaUrlCtrl = TextEditingController(text: settings.localLlmBaseUrl);
    _customEndpointCtrl = TextEditingController(text: settings.customEndpoint);
    _customKeyCtrl = TextEditingController(text: settings.customApiKey);
    _systemPromptCtrl = TextEditingController(text: settings.systemPrompt);
  }

  @override
  void dispose() {
    _geminiKeyCtrl.dispose();
    _grokKeyCtrl.dispose();
    _alibabaKeyCtrl.dispose();
    _ollamaUrlCtrl.dispose();
    _customEndpointCtrl.dispose();
    _customKeyCtrl.dispose();
    _systemPromptCtrl.dispose();
    super.dispose();
  }

  void _saveConfigs() {
    context.read<SettingsBloc>().add(
          UpdateApiKeyConfigEvent(
            geminiApiKey: _geminiKeyCtrl.text.trim(),
            grokApiKey: _grokKeyCtrl.text.trim(),
            alibabaApiKey: _alibabaKeyCtrl.text.trim(),
            localLlmBaseUrl: _ollamaUrlCtrl.text.trim(),
            customEndpoint: _customEndpointCtrl.text.trim(),
            customApiKey: _customKeyCtrl.text.trim(),
            systemPrompt: _systemPromptCtrl.text.trim(),
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI Engine settings saved to local database'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Engine & Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            tooltip: 'Save Settings',
            onPressed: _saveConfigs,
          ),
        ],
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state.settings.geminiApiKey != _geminiKeyCtrl.text) {
            _geminiKeyCtrl.text = state.settings.geminiApiKey;
          }
          if (state.settings.grokApiKey != _grokKeyCtrl.text) {
            _grokKeyCtrl.text = state.settings.grokApiKey;
          }
          if (state.settings.alibabaApiKey != _alibabaKeyCtrl.text) {
            _alibabaKeyCtrl.text = state.settings.alibabaApiKey;
          }
          if (state.settings.localLlmBaseUrl != _ollamaUrlCtrl.text) {
            _ollamaUrlCtrl.text = state.settings.localLlmBaseUrl;
          }
          if (state.settings.customEndpoint != _customEndpointCtrl.text) {
            _customEndpointCtrl.text = state.settings.customEndpoint;
          }
          if (state.settings.customApiKey != _customKeyCtrl.text) {
            _customKeyCtrl.text = state.settings.customApiKey;
          }
          if (state.settings.systemPrompt != _systemPromptCtrl.text) {
            _systemPromptCtrl.text = state.settings.systemPrompt;
          }
        },
        builder: (context, state) {
          final settings = state.settings;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // PROVIDER SELECTION
              _buildSectionHeader('AI PROVIDER'),
              RadioGroup<String>(
                groupValue: settings.activeAiProvider,
                onChanged: (val) {
                  if (val != null) {
                    context.read<SettingsBloc>().add(ChangeAiProviderEvent(val));
                  }
                },
                child: Column(
                  children: AiProviderRegistry.supportedProviders.map((provider) {
                    final isSelected = settings.activeAiProvider == provider.id;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        leading: Radio<String>(
                          value: provider.id,
                        ),
                    title: Row(
                      children: [
                        Text(
                          provider.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        if (provider.isOfflineCapable)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.4)),
                            ),
                            child: const Text(
                              'OFFLINE',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text(
                      provider.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.6),
                      ),
                    ),
                    onTap: () => context
                        .read<SettingsBloc>()
                        .add(ChangeAiProviderEvent(provider.id)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

              // PROVIDER CONFIGURATION
              _buildSectionHeader('PROVIDER CONFIGURATION'),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (settings.activeAiProvider == 'local') ...[
                        TextField(
                          controller: _ollamaUrlCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Ollama Base URL',
                            hintText: 'http://localhost:11434',
                            helperText:
                                'Local or LAN address of your Ollama instance',
                            prefixIcon: Icon(Icons.dns_outlined),
                          ),
                          onChanged: (_) => _saveConfigs(),
                        ),
                      ] else if (settings.activeAiProvider == 'gemini') ...[
                        TextField(
                          controller: _geminiKeyCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Google AI Studio API Key',
                            hintText: 'AIzaSy...',
                            helperText:
                                'Get a free key at aistudio.google.com',
                            prefixIcon: Icon(Icons.key_outlined),
                          ),
                          onChanged: (_) => _saveConfigs(),
                        ),
                      ] else if (settings.activeAiProvider == 'grok') ...[
                        TextField(
                          controller: _grokKeyCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'xAI Grok API Key',
                            hintText: 'xai-...',
                            helperText: 'Obtain from console.x.ai',
                            prefixIcon: Icon(Icons.key_outlined),
                          ),
                          onChanged: (_) => _saveConfigs(),
                        ),
                      ] else if (settings.activeAiProvider == 'alibaba') ...[
                        TextField(
                          controller: _alibabaKeyCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Alibaba DashScope API Key',
                            hintText: 'sk-...',
                            helperText: 'Obtain from aliyun.com DashScope console',
                            prefixIcon: Icon(Icons.key_outlined),
                          ),
                          onChanged: (_) => _saveConfigs(),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _customEndpointCtrl,
                          decoration: const InputDecoration(
                            labelText: 'DashScope Endpoint (Optional)',
                            hintText:
                                'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/chat/completions',
                            prefixIcon: Icon(Icons.link_rounded),
                          ),
                          onChanged: (_) => _saveConfigs(),
                        ),
                      ] else if (settings.activeAiProvider ==
                          'openai_compatible') ...[
                        TextField(
                          controller: _customEndpointCtrl,
                          decoration: const InputDecoration(
                            labelText: 'API Endpoint URL',
                            hintText: 'https://api.openai.com/v1/chat/completions',
                            helperText:
                                'OpenAI-compatible /chat/completions URL',
                            prefixIcon: Icon(Icons.link_rounded),
                          ),
                          onChanged: (_) => _saveConfigs(),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _customKeyCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'API Key (Optional)',
                            hintText: 'Bearer token or API Key',
                            prefixIcon: Icon(Icons.key_outlined),
                          ),
                          onChanged: (_) => _saveConfigs(),
                        ),
                      ] else ...[
                        const Text(
                          'Neural AI Mock is fully offline and requires no API keys.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // System Prompt
                      TextField(
                        controller: _systemPromptCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'System Prompt',
                          helperText: 'Instructions given to the AI model',
                          prefixIcon: Icon(Icons.psychology_outlined),
                        ),
                        onChanged: (_) => _saveConfigs(),
                      ),
                      const SizedBox(height: 16),

                      // Test Connection Action
                      Row(
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: state.testStatus == TestStatus.testing
                                ? null
                                : () => context
                                    .read<SettingsBloc>()
                                    .add(const TestConnectionEvent()),
                            icon: state.testStatus == TestStatus.testing
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.network_check_rounded),
                            label: const Text('Test Connection'),
                          ),
                        ],
                      ),
                      if (state.testResult.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: state.testStatus == TestStatus.success
                                ? Colors.green.withValues(alpha: 0.1)
                                : (state.testStatus == TestStatus.error
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : theme.colorScheme.surfaceContainerHighest
                                        .withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: state.testStatus == TestStatus.success
                                  ? Colors.green.withValues(alpha: 0.3)
                                  : (state.testStatus == TestStatus.error
                                      ? Colors.red.withValues(alpha: 0.3)
                                      : Colors.transparent),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                state.testStatus == TestStatus.success
                                    ? Icons.check_circle_outline
                                    : (state.testStatus == TestStatus.error
                                        ? Icons.error_outline
                                        : Icons.info_outline),
                                size: 18,
                                color: state.testStatus == TestStatus.success
                                    ? Colors.green
                                    : (state.testStatus == TestStatus.error
                                        ? Colors.red
                                        : theme.textTheme.bodyMedium?.color),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.testResult,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: state.testStatus ==
                                            TestStatus.success
                                        ? Colors.green
                                        : (state.testStatus == TestStatus.error
                                            ? Colors.red
                                            : theme.textTheme.bodyMedium?.color),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // APPEARANCE / THEME
              _buildSectionHeader('APPEARANCE'),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ThemeOptionCard(
                          title: 'Dark',
                          isSelected: settings.themeMode == AppThemeType.dark,
                          bgColor: const Color(0xFF1E1E22),
                          textColor: Colors.white,
                          onTap: () => context.read<SettingsBloc>().add(
                              const ChangeThemeModeEvent(AppThemeType.dark)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ThemeOptionCard(
                          title: 'Light',
                          isSelected: settings.themeMode == AppThemeType.light,
                          bgColor: const Color(0xFFFFFFFF),
                          textColor: Colors.black,
                          onTap: () => context.read<SettingsBloc>().add(
                              const ChangeThemeModeEvent(AppThemeType.light)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ThemeOptionCard(
                          title: 'Sepia',
                          isSelected: settings.themeMode == AppThemeType.sepia,
                          bgColor: const Color(0xFFF4ECD8),
                          textColor: const Color(0xFF4A3B32),
                          onTap: () => context.read<SettingsBloc>().add(
                              const ChangeThemeModeEvent(AppThemeType.sepia)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  const _ThemeOptionCard({
    required this.title,
    required this.isSelected,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.grey.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.grey.withValues(alpha: 0.3),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

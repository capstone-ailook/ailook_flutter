import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ailook_flutter/presentation/widgets/base/base_page.dart';
import 'package:ailook_flutter/presentation/pages/onboarding/onboarding_event.dart';

class OnboardingPage extends BasePage with OnboardingEvent {
  const OnboardingPage({super.key});

  @override
  bool get wrapWithSafeArea => false;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return _OnboardingBody(
      onSubmit: (gender, height, weight, age, nickname) => submitProfile(
        context: context,
        ref: ref,
        gender: gender,
        height: height,
        weight: weight,
        age: age,
        nickname: nickname,
      ),
      onBack: () => handleLogout(context, ref),
    );
  }
}

class _OnboardingBody extends StatefulWidget {
  final Future<void> Function(String?, String?, String?, String?, String?)
  onSubmit;
  final VoidCallback onBack;
  const _OnboardingBody({required this.onSubmit, required this.onBack});

  @override
  State<_OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<_OnboardingBody> {
  late final PageController _pageController;
  int _currentPage = 0;
  final bool _isLoading = false;

  String? _gender;
  String? _height;
  String? _weight;
  String? _age;
  String? _nickname;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      widget.onSubmit(
        _gender,
        _height,
        _weight,
        _age,
        _nickname,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      widget.onBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _previousPage();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: _previousPage,
          ),
          title: const Text(
            '프로필 설정',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  4,
                  (index) => _buildDot(index, _currentPage),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  children: [
                    _GenderPage(
                      selected: _gender,
                      onSelect: (val) => setState(() => _gender = val),
                    ),
                    _BodyInfoPage(
                      onHeightChanged: (val) => _height = val,
                      onWeightChanged: (val) => _weight = val,
                    ),
                    _AgePage(
                      selected: _age,
                      onSelect: (val) => setState(() => _age = val),
                    ),
                    _NicknamePage(
                      onChanged: (val) => _nickname = val,
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _nextPage,
                    child: Text(
                      _currentPage == 3 ? '완료하기' : '다음으로',
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

  Widget _buildDot(int index, int currentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.black : Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );
  }
}

// ── 성별 페이지 ──────────────────────────────────────────────
class _GenderPage extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  const _GenderPage({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '성별이 어떻게 되시나요?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '성별 맞춤형 코디를 추천해 드려요',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(child: _GenderButton(label: '남성', selected: selected, onSelect: onSelect)),
              const SizedBox(width: 16),
              Expanded(child: _GenderButton(label: '여성', selected: selected, onSelect: onSelect)),
            ],
          ),
        ],
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final String? selected;
  final ValueChanged<String> onSelect;
  const _GenderButton({required this.label, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == label;
    return GestureDetector(
      onTap: () => onSelect(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

// ── 신체 정보 페이지 ─────────────────────────────────────────
class _BodyInfoPage extends StatelessWidget {
  final ValueChanged<String> onHeightChanged;
  final ValueChanged<String> onWeightChanged;
  const _BodyInfoPage({required this.onHeightChanged, required this.onWeightChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '신체 정보가 어떻게 되시나요?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '신체 정보를 반영하여 핏을 추천해 드려요',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 40),
          TextField(
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              labelText: '키',
              suffixText: 'cm',
              border: UnderlineInputBorder(),
            ),
            onChanged: onHeightChanged,
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              labelText: '몸무게',
              suffixText: 'kg',
              border: UnderlineInputBorder(),
            ),
            onChanged: onWeightChanged,
          ),
        ],
      ),
    );
  }
}

// ── 연령대 페이지 ─────────────────────────────────────────────
class _AgePage extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onSelect;
  const _AgePage({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '연령대가 어떻게 되시나요?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            '연령대를 고려하여 코디를 추천해 드려요',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 40),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(border: UnderlineInputBorder()),
            initialValue: selected,
            hint: const Text('연령대 선택'),
            style: const TextStyle(color: Colors.black),
            dropdownColor: Colors.white,
            items: ['10대', '20대', '30대', '40대', '50대 이상']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onSelect,
          ),
        ],
      ),
    );
  }
}

// ── 닉네임 페이지 ─────────────────────────────────────────────
class _NicknamePage extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _NicknamePage({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '닉네임이 어떻게 되시나요?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'AI가 코디를 추천할 때 사용할 닉네임이에요',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 40),
          TextField(
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              labelText: '닉네임',
              border: UnderlineInputBorder(),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

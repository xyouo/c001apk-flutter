import 'package:c001apk_flutter/router/app_pages.dart';
import 'package:c001apk_flutter/router/opaque_content_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('routes use an opaque custom transition', () {
    for (final page in AppPages.getPages) {
      expect(
        page.customTransition,
        isA<OpaqueContentTransition>(),
        reason: page.name,
      );
      expect(
        page.transitionDuration,
        const Duration(milliseconds: 300),
        reason: page.name,
      );
    }
  });

  testWidgets('route content uses a smooth horizontal transition',
      (tester) async {
    final controller = AnimationController(
      vsync: tester,
      duration: const Duration(milliseconds: 300),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Theme(
          data: ThemeData(),
          child: Builder(
            builder: (context) => OpaqueContentTransition().buildTransition(
              context,
              Curves.linear,
              null,
              controller,
              const AlwaysStoppedAnimation<double>(0),
              const SizedBox(),
            ),
          ),
        ),
      ),
    );

    final fade = tester.widget<FadeTransition>(find.byType(FadeTransition));
    final slide = tester.widget<SlideTransition>(find.byType(SlideTransition));

    expect(fade.opacity.value, closeTo(0.88, 0.001));
    expect(slide.position.value, const Offset(0.08, 0));
    expect(find.byType(ScaleTransition), findsNothing);
  });
}

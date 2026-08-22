import 'package:c001apk_flutter/logic/model/feed/datum.dart';
import 'package:c001apk_flutter/logic/state/loading_state.dart';
import 'package:c001apk_flutter/pages/common/common_controller.dart';
import 'package:flutter_test/flutter_test.dart';

class _CursorController extends CommonController {
  _CursorController(this.items);

  final List<Datum> items;

  @override
  Future<LoadingState> customGetData() async => LoadingState.success(items);
}

void main() {
  test('pagination cursors use the first and last non-null IDs', () async {
    final controller = _CursorController([
      Datum(id: null),
      Datum(id: 12),
      Datum(id: '34'),
      Datum(id: null),
    ]);

    await controller.onGetData();

    expect(controller.firstItem, '12');
    expect(controller.lastItem, '34');
    final state = controller.loadingState.value;
    expect(state, isA<Success>());
    expect((state as Success).response, hasLength(4));
  });

  test('pagination cursors remain null when all IDs are null', () async {
    final controller = _CursorController([Datum(id: null), Datum(id: null)]);

    await controller.onGetData();

    expect(controller.firstItem, isNull);
    expect(controller.lastItem, isNull);
  });
}

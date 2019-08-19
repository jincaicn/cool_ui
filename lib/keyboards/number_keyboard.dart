part of cool_ui;

class NumberKeyboard extends StatelessWidget {
  static const CKTextInputType inputType =
      const CKTextInputType(name: 'CKNumberKeyboard');
  static double getHeight(BuildContext ctx) {
    MediaQueryData mediaQuery = MediaQuery.of(ctx);
    return mediaQuery.size.width / 3 / 2 * 4;
  }

  final KeyboardController controller;
  NumberKeyboard({this.controller});

  static register() {
    CoolKeyboard.addKeyboard(
        NumberKeyboard.inputType,
        KeyboardConfig(
            builder: (context, controller) {
              return NumberKeyboard(controller: controller);
            },
            getHeight: NumberKeyboard.getHeight));
  }

  static Map<int, FocusNode> _map = Map();
  static FocusNode _currentNode;
  static int _currentIndex = 0;
  static BuildContext ctx;

  setKeyboardActions(BuildContext context, List<FocusNode> actions) {
    ctx = context;
    _map = Map();
    for (var i = 0; i < actions.length; i++) {
      FocusNode action = actions[i];
      _map[i] = action;
    }
  }

  onTapUp() {
    if (_previousIndex != null) {
      final currentAction = _map[_previousIndex];
      shouldGoToNextFocus(currentAction, _previousIndex);
    }
  }

  onTapDown() {
    if (_nextIndex != null) {
      final currentAction = _map[_nextIndex];
      shouldGoToNextFocus(currentAction, _nextIndex);
    } else {
      clear();
    }
  }

  clear() {
    if (ctx != null) {
      FocusScope.of(ctx).requestFocus(FocusNode());
    }
  }

  /// The current previous index, or null.
  int get _previousIndex {
    final nextIndex = _currentIndex - 1;
    return nextIndex >= 0 ? nextIndex : null;
  }

  /// The current next index, or null.
  int get _nextIndex {
    final nextIndex = _currentIndex + 1;
    return nextIndex < _map.length ? nextIndex : null;
  }

  shouldGoToNextFocus(FocusNode focusNode, int nextIndex) {
    if (focusNode != null) {
      _currentNode = focusNode;
      _currentIndex = nextIndex;
      FocusScope.of(ctx).requestFocus(_currentNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Material(
      child: DefaultTextStyle(
        style: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.black, fontSize: 23.0),
        child: Container(
          height: getHeight(context),
          width: mediaQuery.size.width,
          decoration: BoxDecoration(
            color: Color(0xffafafaf),
          ),
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 2 / 1,
            mainAxisSpacing: 0.5,
            crossAxisSpacing: 0.5,
            padding: EdgeInsets.all(0.0),
            crossAxisCount: 3,
            children: <Widget>[
              buildButton('1'),
              buildButton('2'),
              buildButton('3'),
              buildButton('4'),
              buildButton('5'),
              buildButton('6'),
              buildButton('7'),
              buildButton('8'),
              buildButton('9'),
              Container(
                color: Color(0xFFd3d6dd),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Center(
                    child: Icon(Icons.expand_more),
                  ),
                  onTap: () {
                    controller.doneAction();
                  },
                ),
              ),
              buildButton('0'),
              Container(
                color: Color(0xFFd3d6dd),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Center(
                    child: Icon(Icons.backspace),
                  ),
                  onTap: () {
                    if (controller.text.isEmpty) {
                      onTapUp();
                      return;
                    }
                    controller.deleteOne();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton(String title, {String value}) {
    if (value == null) {
      value = title;
    }
    return Container(
      color: Colors.white,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Center(
          child: Text(title),
        ),
        onTap: () {
          controller.addText(value);
        },
      ),
    );
  }
}

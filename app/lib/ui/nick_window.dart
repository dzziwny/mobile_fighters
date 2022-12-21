import 'package:bubble_fight/consts.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:bubble_fight/theme.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import 'google_pixel_7.dart';
import 'iphone_14.dart';
import 'player_widget.dart';

class NickWindow extends StatefulWidget {
  const NickWindow({
    Key? key,
  }) : super(key: key);

  @override
  State<NickWindow> createState() => _NickWindowState();
}

class _NickWindowState extends State<NickWindow> {
  final nickController = TextEditingController(
    text: kDebugMode ? defaultTargetPlatform.name : null,
  );
  // final nickController = TextEditingController();
  final client = GetIt.I<ServerClient>();
  int selectedIndex = 0;
  var selectedDevice = Device.pixel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      // can be used with joystic
      // shape: CircleBorder(),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Card(
                    child: SizedBox(
                      width: 240.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          controller: nickController,
                          decoration: const InputDecoration(
                            labelText: 'Type a nickname',
                            counterText: '',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => setState(() {}),
                          maxLength: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 8,
                      child: Column(
                        children: [
                          Text(
                            'Choose the warior',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Expanded(child: WarriorChooser(
                            onChange: (value, Device device) {
                              setState(() {
                                selectedDevice = device;
                                selectedIndex = value;
                              });
                            },
                          )),
                        ],
                      ),
                    ),
                    const VerticalDivider(),
                    Flexible(
                      flex: 5,
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              nickController.text,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.error,
                              ),
                            ),
                            const SizedBox(height: 32.0),
                            Expanded(
                              child: FittedBox(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: selectedIndex == 0
                                      ? const GooglePixel7()
                                      : const IPhone14(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32.0),
                            ElevatedButton.icon(
                              label: const Text('Play'),
                              onPressed: nickController.text == ''
                                  ? null
                                  : () {
                                      client.createPlayer(
                                        nickController.text,
                                        selectedDevice,
                                      );
                                    },
                              icon: const Icon(Icons.play_arrow_rounded),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WarriorChooser extends StatefulWidget {
  const WarriorChooser({
    Key? key,
    required this.onChange,
  }) : super(key: key);

  final void Function(int, Device) onChange;

  @override
  State<WarriorChooser> createState() => _WarriorChooserState();
}

class _WarriorChooserState extends State<WarriorChooser> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const height = 100.0;
        var count = width ~/ 117;
        final ratio = width / count / height;
        return GridView.count(
          crossAxisCount: count,
          childAspectRatio: ratio,
          children: [
            ChooseWarriorSelectCard(
              name: 'Google Pixel 7',
              selected: selected == 0,
              child: const GooglePixel7(),
              onTap: () {
                setState(() {
                  selected = 0;
                  widget.onChange(0, Device.pixel);
                });
              },
            ),
            ChooseWarriorSelectCard(
              name: 'Google Pixel 6',
              selected: false,
              enabled: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Icon(
                  Icons.no_cell_outlined,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ),
            ChooseWarriorSelectCard(
              name: 'Google Pixel 5',
              selected: false,
              enabled: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Icon(
                  Icons.no_cell_outlined,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ),
            ChooseWarriorSelectCard(
              name: 'Google Pixel 4',
              selected: false,
              enabled: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Icon(
                  Icons.no_cell_outlined,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ),
            ChooseWarriorSelectCard(
              name: 'Apple iPhone 14',
              selected: selected == 1,
              child: const IPhone14(),
              onTap: () {
                setState(() {
                  selected = 1;
                  widget.onChange(1, Device.iphone);
                });
              },
            ),
            ChooseWarriorSelectCard(
              name: 'Apple iPhone 13',
              selected: false,
              enabled: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Icon(
                  Icons.no_cell_outlined,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ),
            ChooseWarriorSelectCard(
              name: 'Apple iPhone 12',
              selected: false,
              enabled: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Icon(
                  Icons.no_cell_outlined,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ),
            ChooseWarriorSelectCard(
              name: 'Apple iPhone 11',
              selected: false,
              enabled: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Icon(
                  Icons.no_cell_outlined,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ChooseWarriorSelectCard extends StatelessWidget {
  const ChooseWarriorSelectCard({
    Key? key,
    required this.name,
    required this.selected,
    required this.child,
    this.onTap,
    this.enabled = true,
  }) : super(key: key);

  final String name;
  final bool enabled;
  final bool selected;
  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: enabled
          ? selected
              ? null
              : 4.0
          : 0.0,
      child: InkWell(
        focusColor: Colors.transparent,
        onTap: enabled && !selected ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: FittedBox(child: child)),
              const SizedBox(height: 8.0),
              Text(name, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

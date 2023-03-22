import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:value_stream_builder/value_stream_builder.dart';

class FragsLayer extends StatelessWidget {
  const FragsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueStreamBuilder(
      stream: fragBloc.frags,
      builder: (context, snapshot) {
        final frags = snapshot.data;
        return Column(
          children: frags
              .map(
                (frag) => FragRow(frag: frag, theme: theme),
              )
              .toList(),
        );
      },
    );
  }
}

class FragRow extends StatelessWidget {
  final ThemeData theme;
  final FragDto frag;

  const FragRow({
    super.key,
    required this.frag,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            frag.killer,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: frag.killerTeam == Team.blue ? Colors.blue : Colors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 32.0),
          Image.asset('assets/dead.png', height: 40.0, width: 40.0),
          const SizedBox(width: 24.0),
          Text(
            frag.enemy,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: frag.enemyTeam == Team.blue ? Colors.blue : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

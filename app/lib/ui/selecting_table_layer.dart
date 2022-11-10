import 'package:flutter/material.dart';

import 'selecting_team_table.dart';

class SelectingTableLayer extends StatelessWidget {
  const SelectingTableLayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      child: SizedBox(
        width: 200.0,
        height: 200.0,
        child: FittedBox(child: SelectingTeamTable()),
      ),
    );
  }
}

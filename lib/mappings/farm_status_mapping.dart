import 'dart:ui';

import '../theme/colors.dart';

Map<String, String> farmStatusMapping = {
  'up-to-date': 'Farm soil data is up-to-date.',
  'new-data-soon': 'It is recommended to get new sensory data soon.',
  'immediate-reporting': 'Immediate reporting needed for soil.',
  'no-data': 'No farm soil record found, please enter sensory data.'
};

Map<String, Color> farmStatusColorMapping = {
  'up-to-date': CustomColors.astarteGreen,
  'new-data-soon': CustomColors.astarteBlue,
  'immediate-reporting': CustomColors.astarteRed,
  'no-data': CustomColors.astarteBlack
};
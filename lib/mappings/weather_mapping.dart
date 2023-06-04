import 'package:flutter/material.dart';

Map<int, Map<String, dynamic>> weatherCodeMapping = {
  0: {
    'description': 'Clear sky',
    'icon': Icons.wb_sunny,
  },
  1: {
    'description': 'Mainly clear',
    'icon': Icons.wb_cloudy,
  },
  2: {
    'description': 'Partly cloudy',
    'icon': Icons.wb_cloudy,
  },
  3: {
    'description': 'Overcast',
    'icon': Icons.cloud,
  },
  45: {
    'description': 'Fog and depositing rime fog',
    'icon': Icons.cloud,
  },
  48: {
    'description': 'Fog and depositing rime fog',
    'icon': Icons.cloud,
  },
  51: {
    'description': 'Drizzle: Light intensity',
    'icon': Icons.grain,
  },
  53: {
    'description': 'Drizzle: Moderate intensity',
    'icon': Icons.grain,
  },
  55: {
    'description': 'Drizzle: Dense intensity',
    'icon': Icons.grain,
  },
  56: {
    'description': 'Freezing Drizzle: Light intensity',
    'icon': Icons.ac_unit,
  },
  57: {
    'description': 'Freezing Drizzle: Dense intensity',
    'icon': Icons.ac_unit,
  },
  61: {
    'description': 'Rain: Slight intensity',
    'icon': Icons.water_drop,
  },
  63: {
    'description': 'Rain: Moderate intensity',
    'icon': Icons.water_drop,
  },
  65: {
    'description': 'Rain: Heavy intensity',
    'icon': Icons.water_drop,
  },
  66: {
    'description': 'Freezing Rain: Light intensity',
    'icon': Icons.ac_unit,
  },
  67: {
    'description': 'Freezing Rain: Heavy intensity',
    'icon': Icons.ac_unit,
  },
  71: {
    'description': 'Snowfall: Slight intensity',
    'icon': Icons.ac_unit,
  },
  73: {
    'description': 'Snowfall: Moderate intensity',
    'icon': Icons.ac_unit,
  },
  75: {
    'description': 'Snowfall: Heavy intensity',
    'icon': Icons.ac_unit,
  },
  77: {
    'description': 'Snow grains',
    'icon': Icons.ac_unit,
  },
  80: {
    'description': 'Rain showers: Slight intensity',
    'icon': Icons.beach_access,
  },
  81: {
    'description': 'Rain showers: Moderate intensity',
    'icon': Icons.beach_access,
  },
  82: {
    'description': 'Rain showers: Violent intensity',
    'icon': Icons.beach_access,
  },
  85: {
    'description': 'Snow showers: Slight intensity',
    'icon': Icons.ac_unit,
  },
  86: {
    'description': 'Snow showers: Heavy intensity',
    'icon': Icons.ac_unit,
  },
  95: {
    'description': 'Thunderstorm: Slight or moderate',
    'icon': Icons.flash_on,
  },
  96: {
    'description': 'Thunderstorm with slight hail',
    'icon': Icons.flash_on,
  },
  99: {
    'description': 'Thunderstorm with heavy hail',
    'icon': Icons.flash_on,
  },
};


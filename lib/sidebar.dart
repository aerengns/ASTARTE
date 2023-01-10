import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar(BuildContext context, {Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Someone'),
            accountEmail: const Text('example@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text("Home"),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => Navigator.popUntil(context, ModalRoute.withName('/')),
          ),
          ListTile(
            leading: const Icon(Icons.addchart),
            title: const Text('Reports'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => Navigator.pushNamed(context, '/reports'),
          ),
          ListTile(
            leading: const Icon(Icons.people_alt_rounded),
            title: const Text('Workers'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => Navigator.pushNamed(context, '/workers'),
          ),
          ListTile(
            leading: const Icon(Icons.warehouse_rounded),
            title: const Text('Farms'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => Navigator.pushNamed(context, '/farms'),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt_rounded),
            title: const Text('Photo Upload'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => Navigator.pushNamed(context, '/photo-upload'),
          ),
          ListTile(
            leading: const Icon(Icons.map_rounded),
            title: const Text('Heatmap'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => Navigator.pushNamed(context, '/heatmap'),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: const Text('Calendar'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => Navigator.pushNamed(context, '/calendar'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Settings'),
            onTap: () => null,
          ),
          ListTile(
            leading: const Icon(Icons.description_rounded),
            title: const Text('Policies'),
            onTap: () => null,
          ),
          const Divider(),
          ListTile(
            title: const Text('Sign Out'),
            leading: const Icon(Icons.logout_rounded),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.popAndPushNamed(context, '/sign_in');
            },
          ),
        ],
      ),
    );
  }
}

class AstarteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AstarteAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: const Color.fromRGBO(211, 47, 47, 1),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

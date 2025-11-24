import 'package:beauty_center/features/customer/presentation/pages/customer_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/service/presentation/pages/service_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Widget listesini state'in içine alalım ki dinamik olabilsin.
  late final List<Widget> _widgetOptions;
  late final List<BottomNavigationBarItem> _navBarItems;

  @override
  void initState() {
    super.initState();
    final userRole = (context.read<AuthBloc>().state as AuthSuccess).user.role;

    // Temel sayfalar
    _widgetOptions = <Widget>[
      const Center(child: Text('Randevular Sayfası')),
      const CustomerListPage(),
      const Center(child: Text('Profil/Ayarlar Sayfası')),
    ];

    _navBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today),
        label: 'Randevular',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.people),
        label: 'Müşteriler',
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
    ];

    // Eğer kullanıcı 'admin' ise, Yönetim sayfasını ve ikonunu ekle
    if (userRole == 'admin') {
      _widgetOptions.add(const ServiceListPage()); // Hizmet sayfamızı ekliyoruz
      _navBarItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Yönetim',
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.watch<AuthBloc>().state as AuthSuccess).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hoş Geldin, ${user.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutButtonPressed());
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _navBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType
            .fixed, // 4 veya daha fazla item olduğunda layout'un bozulmasını engeller
      ),
    );
  }
}

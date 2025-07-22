import 'package:blind_clone_flutter/data/post_repository.dart';
import 'package:blind_clone_flutter/firebase_options.dart';
import 'package:blind_clone_flutter/ui/home/home_bloc.dart';
import 'package:blind_clone_flutter/ui/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blind Clone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainPage(),
    );
  }
}

// 탭의 상태를 관리하는 메인 페이지 (StatefulWidget)
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 현재 선택된 탭의 인덱스를 저장할 변수
  int _selectedIndex = 0;

  // 각 탭에 해당하는 페이지 위젯들을 리스트로 정의
  static final List<Widget> _widgetOptions = <Widget>[
    // 각 탭을 눌렀을 때 보여줄 페이지 위젯들
    BlocProvider(
      create: (context) => HomeBloc(postRepository: PostRepository()),
      child: const HomeScreen(),
    ),
    PlaceholderPage(pageTitle: '검색'),
    PlaceholderPage(pageTitle: '추가'),
    PlaceholderPage(pageTitle: '알림'),
    PlaceholderPage(pageTitle: '설정'),
  ];

  // 탭이 선택되었을 때 호출될 함수
  void _onItemTapped(int index) {
    // setState를 호출하여 _selectedIndex를 업데이트하고 위젯을 다시 빌드(화면 갱신)
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // _selectedIndex에 따라 _widgetOptions 리스트에서 적절한 페이지를 선택하여 표시
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: '추가',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '알림'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
        currentIndex: _selectedIndex, // 현재 활성화된 탭 인덱스
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // 4개 이상 탭에서 디자인이 바뀌지 않도록 고정
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String pageTitle;

  const PlaceholderPage({super.key, required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$pageTitle 페이지',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

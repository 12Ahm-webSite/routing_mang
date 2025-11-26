import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

// =========================================================================
// 1. إعداد GoRouter (Router Configuration)
// =========================================================================

final GoRouter _router = GoRouter(
  // قائمة تعريف المسارات
  routes: <RouteBase>[
    // المسار الرئيسي (Home Route)
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen(title: 'الشاشة الرئيسية');
      },
    ),
    // مسار التفاصيل (Details Route) - يتطلب معلمة :id
    GoRoute(
      path: '/details/:id',
      builder: (BuildContext context, GoRouterState state) {
        // استخراج المعلمة 'id' من المسار.
        final String itemId = state.pathParameters['id'] ?? 'N/A';
        return DetailsScreen(itemId: itemId);
      },
    ),
  ],
  // شاشة خاصة تظهر في حال عدم العثور على المسار المطلوب (404)
  errorBuilder: (context, state) => const ErrorScreen(),
);

// =========================================================================
// 2. تطبيق MyApp يستخدم MaterialApp.router
// =========================================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // 🔑 استخدام MaterialApp.router وتمرير routerConfig
      title: 'Flutter GoRouter Demo',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Cairo', // هنا الخط شغال
      ),
    );
  }
}

// =========================================================================
// 3. الشاشة الرئيسية (HomeScreen)
// =========================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('تم الضغط على الزر هذا العدد من المرات:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 30),
            // التنقل باستخدام context.go (يستبدل الشاشة الحالية)
            ElevatedButton(
              onPressed: () {
                // التنقل إلى مسار '/details/42'
                context.go('/details/42');
              },
              child: const Text('انتقال (Go) إلى التفاصيل ID: 42'),
            ),
            const SizedBox(height: 10),
            // التنقل باستخدام context.push (يضيف الشاشة إلى المكدس)
            ElevatedButton(
              onPressed: () {
                // التنقل إلى مسار '/details/99'
                context.push('/details/99');
              },
              child: const Text('دفع (Push) شاشة التفاصيل ID: 99'),
            ),
            const SizedBox(height: 10),
            // التنقل إلى مسار غير موجود لاختبار errorBuilder
            ElevatedButton(
              onPressed: () {
                context.go('/non-existent-path');
              },
              child: const Text('اختبار شاشة الخطأ (404)'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'إضافة',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// =========================================================================
// 4. شاشة التفاصيل (DetailsScreen)
// =========================================================================

class DetailsScreen extends StatelessWidget {
  final String itemId;
  const DetailsScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('شاشة التفاصيل'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'أنت الآن في شاشة التفاصيل للعنصر رقم:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              itemId,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 30),
            // العودة باستخدام context.pop
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('العودة إلى الشاشة السابقة (Pop)'),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// 5. شاشة الخطأ (ErrorScreen)
// =========================================================================

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خطأ في التوجيه'),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'عذراً، لم يتم العثور على الصفحة (404).',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // العودة إلى الشاشة الرئيسية
                context.go('/');
              },
              child: const Text('العودة إلى الرئيسية'),
            ),
          ],
        ),
      ),
    );
  }
}
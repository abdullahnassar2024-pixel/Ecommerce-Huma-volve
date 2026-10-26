import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'core/theme.dart';
import 'features/splash/screens/splash_screen.dart';
import 'dart:async';
import 'features/details/screens/product_details_screen.dart';
import 'features/home/data/home_service.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/usecases/get_product_by_id_usecase.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int? _pendingProductId;
  bool _isHomeReady = false;
  void _onHomeReady() {
    _isHomeReady = true;

    debugPrint('Home Ready Callback Called');
    debugPrint('Pending Product ID: $_pendingProductId');

    final productId = _pendingProductId;
    if (productId == null) return;

    _pendingProductId = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      debugPrint('Opening Product Details: $productId');
      _openProductDetails(productId);
    });
  }

  StreamSubscription<Uri>? _linkSubscription;
  @override
  void initState() {
    super.initState();

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        debugPrint('Received Deep Link: $uri');
        if (uri.scheme == 'humavolve' &&
            uri.host == 'product' &&
            uri.pathSegments.length == 1) {
          final productId = int.tryParse(uri.pathSegments.first);

          if (productId != null && productId > 0) {
            debugPrint('Product ID: $productId');

            _pendingProductId = productId;
            debugPrint('Pending Product ID: $_pendingProductId');
            debugPrint('Is Home Ready: $_isHomeReady');

            if (_isHomeReady) {
              debugPrint('Opening deep link from Home');
              _onHomeReady();
            }
          }
        }
      },
      onError: (Object error) {
        debugPrint('Deep Link Error: $error');
      },
    );
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _openProductDetails(int productId) async {
    try {
      final repository = HomeRepositoryImpl(HomeService());

      final useCase = GetProductByIdUseCase(repository);

      final product = await useCase(productId);

      if (!mounted) return;

      debugPrint('Product loaded: ${product.name}');
      _navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        ),
      );
    } catch (e) {
      debugPrint('Failed to load product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashScreen(onLoginSuccess: _onHomeReady),
    );
  }
}

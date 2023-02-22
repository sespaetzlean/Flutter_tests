import 'package:ecommerce_app/src/features/sortDropdown/sortDropdown_screen.dart';
import 'package:ecommerce_app/src/features/products/presentation/product_screen/product_screen.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/products_list_screen.dart';
import 'package:ecommerce_app/src/features/reviews/presentation/leave_review_screen/leave_review_screen.dart';
import 'package:ecommerce_app/src/routing/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home,
  product,
  leaveReview,
  changeFilter,
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      builder: (context, state) => const ProductsListScreen(),
      routes: [
        GoRoute(
          path: 'product/:id',
          name: AppRoute.product.name,
          builder: (context, state) {
            final productId = state.params['id']!;
            return ProductScreen(productId: productId);
          },
          routes: [
            GoRoute(
              path: 'review',
              name: AppRoute.leaveReview.name,
              pageBuilder: (context, state) {
                final productId = state.params['id']!;
                return MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: LeaveReviewScreen(productId: productId),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'filterDropdown',
          name: AppRoute.changeFilter.name,
          builder: (context, state) => const MySortPage(),
        )
      ],
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);

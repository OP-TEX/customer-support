// import 'package:optex/core/theming/theme.dart';
// import 'package:flutter/material.dart';

// class UniversalBottomBar extends StatelessWidget {
//   final int currentIndex;
//   final void Function(int) onTap;

//   const UniversalBottomBar({
//     Key? key,
//     required this.currentIndex,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor, //isDarkMode
//         // ? ColorsManager.darkModeCardBackground
//         // : Theme.of(context).colorScheme.surface,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.1),
//             blurRadius: 10,
//             offset: Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Semantics(
//           container: true,
//           label: 'core_bottombar_container',
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Divider(
//                 thickness: 0.5,
//                 height: 0,
//                 color: isDarkMode
//                     ? Colors.grey.withOpacity(0.2)
//                     : Colors.grey.withOpacity(0.3),
//               ),
//               SizedBox(
//                 height: 60,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildNavItem(context, 0, Icons.home, 'Home'),
//                     _buildNavItem(context, 1, Icons.category, 'Categories'),
//                     _buildNavItem(context, 2, Icons.person, 'Account'),
//                     _buildNavItem(context, 3, Icons.shopping_cart, 'Cart'),
//                     _buildNavItem(context, 4, Icons.support_agent, 'Support'),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(
//       BuildContext context, int index, IconData icon, String label) {
//     final isSelected = currentIndex == index;
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     // Choose colors based on theme and selection state
//     final selectedColor = AppTheme.primaryColor;
//     //isDarkMode ? ColorsManager.darkCrimsonRed : ColorsManager.darkBurgundy;

//     final unselectedColor = AppTheme.secondaryColor;
//     //isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

//     final backgroundColor = isSelected
//         ? (isDarkMode
//             ? selectedColor.withOpacity(0.15)
//             : selectedColor.withOpacity(0.1))
//         : Colors.transparent;

//     return GestureDetector(
//       onTap: () => onTap(index),
//       behavior: HitTestBehavior.opaque,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AnimatedContainer(
//               duration: Duration(milliseconds: 200),
//               child: Icon(
//                 icon,
//                 color: isSelected ? selectedColor : unselectedColor,
//                 size: isSelected ? 26 : 24,
//               ),
//             ),
//             const SizedBox(height: 4),
//             AnimatedDefaultTextStyle(
//               duration: Duration(milliseconds: 200),
//               style: TextStyle(
//                 color: isSelected ? selectedColor : unselectedColor,
//                 fontSize: isSelected ? 12 : 11,
//                 // fontWeight: isSelected
//                 //     ? FontWeightHelper.semiBold
//                 //     : FontWeightHelper.regular,
//               ),
//               child: Text(label),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // void onTap(BuildContext context, int index){
// //   switch(index)
// //   {
// //     case 0:
// //       Navigator.pushReplacementNamed(context, Routes.homeScreen);
// //       break;
// //     case 1:
// //       Navigator.pushReplacementNamed(context, Routes.categoryScreen);
// //       break;
// //     case 2:
// //       Navigator.pushReplacementNamed(context, Routes.userScreen);
// //       break;
// //     case 3:
// //       Navigator.pushReplacementNamed(context, Routes.cartScreen);
// //       break;
// //     default:
// //       Navigator.pushReplacementNamed(context, Routes.homeScreen);
// //       break;
// //   }
// // }

// class CategoryScreen extends StatelessWidget {
//   const CategoryScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Categories Screen Content'));
//   }
// }

// class AccountScreen extends StatelessWidget {
//   const AccountScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const Center(child: Text('Account Screen Content'));
//   }
// }

// // class CartScreen extends StatelessWidget {
// //   const CartScreen({super.key});
// //   @override
// //   Widget build(BuildContext context) {
// //     return  const Center(child: Text('Cart Screen Content'));
// //   }
// // }


// import 'package:optex/core/theming/text_styles.dart';
// import 'package:optex/core/widgets/custom_search_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// void _onSearchTextChanged(String text) {
//   //  implement search logic here, if needed, or leave empty
//   print('Search term: $text');
// }

// AppBar universalAppBar(
//     {required BuildContext context,
//      String? title,
//     VoidCallback? searchBarFunction}) {
//   final TextEditingController _searchController = TextEditingController();
//   return AppBar(
//     backgroundColor:Theme.of(context).scaffoldBackgroundColor, // Set a background color for the AppBar
//     elevation: 2, // Add a shadow
//     centerTitle: true,
//     title:  searchBarFunction != null 
//         ? SizedBox(
//             width: 250.w, // Adjust the width as needed
//             child:  CustomSearchBar(
//               text: 'Search',
//               onPress: searchBarFunction ,
//               onTextChange: _onSearchTextChanged,
//               controller: _searchController,
//             ) , // Hide the search bar if not needed
//           )
//         : title != null ? Text(
//             //default
//             title ,
//             style: TextStyles.bodyLarge
//                 .copyWith(fontWeight: FontWeight.w500), // Use your text style
//           ) : const SizedBox.shrink(),
//   );
// }

// // New function for sliver app bar
// SliverAppBar universalSliverAppBar({
//   required BuildContext context,
//   String? title,
//   VoidCallback? searchBarFunction,
//   bool floating = true,
//   bool snap = true,
//   bool pinned = false,
// }) {
//   final TextEditingController _searchController = TextEditingController();
//   return SliverAppBar(
//     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//     elevation: 2,
//     centerTitle: true,
//     floating: floating,
//     snap: snap,
//     pinned: pinned,
//     title: searchBarFunction != null
//         ? SizedBox(
//             width: 250.w,
//             child: CustomSearchBar(
//               text: 'Search',
//               onPress: searchBarFunction,
//               onTextChange: _onSearchTextChanged,
//               controller: _searchController,
//             ),
//           )
//         : title != null
//             ? Text(
//                 title,
//                 style: TextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
//               )
//             : const SizedBox.shrink(),
//   );
// }

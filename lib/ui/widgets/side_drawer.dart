import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Widget sideNavDrawer() {
//
//   return Drawer(
//     child: Container(
//       width: double.infinity,
//       height: double.infinity,
//       padding: EdgeInsets.fromLTRB(16.w, 25.h, 10.w, 15.h),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 25.h,
//             ),
//             Row(
//               children: [
//                 Image.asset(
//                   'assets/images/avatar.png',
//                   width: 35.w,
//                   height: 35.w,
//                 ),
//                 SizedBox(
//                   width: 10.w,
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Mahmuda Akter",
//                       style: TextStyle(
//                           fontSize: 16.sp, fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       "mahmudaakterjhumur@gmail.com",
//                       style: TextStyle(
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xff535763)),
//                     )
//                   ],
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 30.h,
//             ),
//             InkWell(
//               onTap: (){
//
//               },
//               child: ExpandableNotifier(
//                   child: ScrollOnExpand(
//                 scrollOnExpand: true,
//                 scrollOnCollapse: false,
//                 child: ExpandablePanel(
//
//                   theme: const ExpandableThemeData(
//                     hasIcon: false,
//                     iconColor: Colors.black,
//                     headerAlignment: ExpandablePanelHeaderAlignment.center,
//                     tapBodyToCollapse: false,
//                   ),
//                   header: Container(
//                     decoration: BoxDecoration(
//                         color: Color(0xffFF8700),
//                         borderRadius: BorderRadius.all(Radius.circular(5.r))),
//                     height: 40.h,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(left: 8.w, right: 10.w),
//                           child: Text(
//                             "Buying Business",
//                             style: TextStyle(
//                               color: Color(0xffffffff),
//                               fontWeight: FontWeight.w600,
//                               fontSize: 12.sp,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 3,
//                           ),
//                         ),
//                         SizedBox(
//                             width: 30.w,
//                             child: Icon(CupertinoIcons.chevron_down,
//                                 size: 12.w, color: Colors.white))
//                       ],
//                     ),
//                   ),
//                   expanded: Container(
//                       margin: EdgeInsets.only(left: 8.w, top: 5.h, bottom: 15.h),
//                       padding:
//                           EdgeInsets.symmetric(vertical: 6.h, horizontal: 15.w),
//                       child: Column(
//                         children: [
//                           GestureDetector(
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.search,
//                                   size: 20.sp,
//                                   color: Color(0xff2965B0),
//                                 ),
//                                 SizedBox(
//                                   width: 10.w,
//                                 ),
//                                 Text(
//                                   'Search Business',
//                                   style: TextStyle(
//                                       color: Color(0xff2965B0),
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 11.sp,
//                                       height: 1.2,
//                                       letterSpacing: 0.1),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {},
//                           ),
//                           SizedBox(
//                             height: 14.h,
//                           ),
//                           GestureDetector(
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.mail_outline_rounded,
//                                   size: 20.sp,
//                                   color: Color(0xff2965B0),
//                                 ),
//                                 SizedBox(
//                                   width: 10.w,
//                                 ),
//                                 Text(
//                                   'Email Alerts',
//                                   style: TextStyle(
//                                       color: Color(0xff2965B0),
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 11.sp,
//                                       height: 1.2,
//                                       letterSpacing: 0.1),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {},
//                           ),
//                           SizedBox(
//                             height: 14.h,
//                           ),
//                           GestureDetector(
//                             child: Row(
//                               children: [
//                                 Image.asset(
//                                   'assets/icons/onclick_msg.png',
//                                   width: 18.sp,
//                                 ),
//                                 SizedBox(
//                                   width: 10.w,
//                                 ),
//                                 Text(
//                                   'On-click Message',
//                                   style: TextStyle(
//                                       color: Color(0xff2965B0),
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 11.sp,
//                                       height: 1.2,
//                                       letterSpacing: 0.1),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {},
//                           ),
//                           SizedBox(
//                             height: 14.h,
//                           ),
//                           GestureDetector(
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   CupertinoIcons.heart,
//                                   size: 20.sp,
//                                   color: Color(0xff2965B0),
//                                 ),
//                                 SizedBox(
//                                   width: 10.w,
//                                 ),
//                                 Text(
//                                   'Saved List',
//                                   style: TextStyle(
//                                       color: Color(0xff2965B0),
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 11.sp,
//                                       height: 1.2,
//                                       letterSpacing: 0.1),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {},
//                           ),
//                           SizedBox(
//                             height: 14.h,
//                           ),
//                           GestureDetector(
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.message_outlined,
//                                   size: 20.sp,
//                                   color: Color(0xff2965B0),
//                                 ),
//                                 SizedBox(
//                                   width: 10.w,
//                                 ),
//                                 Text(
//                                   'Messages',
//                                   style: TextStyle(
//                                       color: Color(0xff2965B0),
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 11.sp,
//                                       height: 1.2,
//                                       letterSpacing: 0.1),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {},
//                           ),
//                           SizedBox(
//                             height: 14.h,
//                           ),
//                           GestureDetector(
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.history_outlined,
//                                   color: Color(0xff2965B0),
//                                 ),
//                                 SizedBox(
//                                   width: 10.w,
//                                 ),
//                                 Text(
//                                   'Enquiry History',
//                                   style: TextStyle(
//                                       color: Color(0xff2965B0),
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 11.sp,
//                                       height: 1.2,
//                                       letterSpacing: 0.1),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {},
//                           ),
//                           SizedBox(
//                             height: 14.h,
//                           ),
//                           GestureDetector(
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.dashboard_outlined,
//                                   size: 18.sp,
//                                   color: Color(0xff2965B0),
//                                 ),
//                                 SizedBox(
//                                   width: 10.w,
//                                 ),
//                                 Text(
//                                   'Find Broker',
//                                   style: TextStyle(
//                                       color: Color(0xff2965B0),
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 11.sp,
//                                       height: 1.2,
//                                       letterSpacing: 0.1),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {},
//                           ),
//                           SizedBox(
//                             height: 14.h,
//                           ),
//                           GestureDetector(
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.person_outline_rounded,
//                                   color: Color(0xff2965B0),
//                                 ),
//                                 SizedBox(
//                                   width: 10.w,
//                                 ),
//                                 Text(
//                                   'Get a Solicitor',
//                                   style: TextStyle(
//                                       color: Color(0xff2965B0),
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 11.sp,
//                                       height: 1.2,
//                                       letterSpacing: 0.1),
//                                 ),
//                               ],
//                             ),
//                             onTap: () {},
//                           ),
//                         ],
//                       )),
//                   builder: (_, collapsed, expanded) {
//                     return Expandable(
//                       collapsed: collapsed,
//                       expanded: expanded,
//                       theme: const ExpandableThemeData(crossFadePoint: 0),
//                     );
//                   },
//                   collapsed: Text(""),
//                 ),
//               )),
//             ),
//             //SizedBox(height: 30.h,),
//             ExpandableNotifier(
//                 child: ScrollOnExpand(
//               scrollOnExpand: true,
//               scrollOnCollapse: false,
//               child: ExpandablePanel(
//                 theme: const ExpandableThemeData(
//                     hasIcon: false,
//                     iconColor: Colors.black,
//                     headerAlignment: ExpandablePanelHeaderAlignment.center,
//                     tapBodyToCollapse: false,
//                     iconPadding: EdgeInsets.zero),
//                 header: Container(
//                   height: 30.h,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.only(left: 8.w, right: 10.w),
//                         child: Text(
//                           "Selling a Business",
//                           style: TextStyle(
//                             color: Color(0xff535763),
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12.sp,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 3,
//                         ),
//                       ),
//                       SizedBox(
//                           width: 30.w,
//                           child: Icon(CupertinoIcons.chevron_down,
//                               size: 12.w, color: Color(0xff535763)))
//                     ],
//                   ),
//                 ),
//                 expanded: Container(
//                   margin: EdgeInsets.only(left: 8.w, top: 5.h, bottom: 15.h),
//                   padding:
//                       EdgeInsets.symmetric(vertical: 6.h, horizontal: 15.w),
//                   child: Column(
//                     children: [
//                       GestureDetector(
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               'assets/icons/viewedit_icon_drawer.png',
//                               width: 18.sp,
//                             ),
//                             SizedBox(
//                               width: 10.w,
//                             ),
//                             Text(
//                               'View & Edit My Advert',
//                               style: TextStyle(
//                                   color: Color(0xff2965B0),
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 11.sp,
//                                   height: 1.2,
//                                   letterSpacing: 0.1),
//                             ),
//                           ],
//                         ),
//                         onTap: () {},
//                       ),
//                       SizedBox(
//                         height: 14.h,
//                       ),
//                       GestureDetector(
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.add_circle_rounded,
//                               size: 20.sp,
//                               color: Color(0xff2965B0),
//                             ),
//                             SizedBox(
//                               width: 10.w,
//                             ),
//                             Text(
//                               'Create Advert',
//                               style: TextStyle(
//                                   color: Color(0xff2965B0),
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 11.sp,
//                                   height: 1.2,
//                                   letterSpacing: 0.1),
//                             ),
//                           ],
//                         ),
//                         onTap: () {},
//                       ),
//                       SizedBox(
//                         height: 14.h,
//                       ),
//                       GestureDetector(
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.message_outlined,
//                               size: 20.sp,
//                               color: Color(0xff2965B0),
//                             ),
//                             SizedBox(
//                               width: 10.w,
//                             ),
//                             Text(
//                               'Messages',
//                               style: TextStyle(
//                                   color: Color(0xff2965B0),
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 11.sp,
//                                   height: 1.2,
//                                   letterSpacing: 0.1),
//                             ),
//                           ],
//                         ),
//                         onTap: () {},
//                       ),
//                       SizedBox(
//                         height: 14.h,
//                       ),
//                       GestureDetector(
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.cancel_rounded,
//                               color: Color(0xff2965B0),
//                             ),
//                             SizedBox(
//                               width: 10.w,
//                             ),
//                             Text(
//                               'Blocked Users',
//                               style: TextStyle(
//                                   color: Color(0xff2965B0),
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 11.sp,
//                                   height: 1.2,
//                                   letterSpacing: 0.1),
//                             ),
//                           ],
//                         ),
//                         onTap: () {},
//                       ),
//                       SizedBox(
//                         height: 14.h,
//                       ),
//                       GestureDetector(
//                         child: Row(
//                           children: [
//                             Image.asset(
//                               'assets/icons/testimonial_icon.png',
//                               width: 18.sp,
//                             ),
//                             SizedBox(
//                               width: 10.w,
//                             ),
//                             Text(
//                               'Testimonials',
//                               style: TextStyle(
//                                   color: Color(0xff2965B0),
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 11.sp,
//                                   height: 1.2,
//                                   letterSpacing: 0.1),
//                             ),
//                           ],
//                         ),
//                         onTap: () {},
//                       ),
//                       SizedBox(
//                         height: 14.h,
//                       ),
//                       GestureDetector(
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.person_outline_rounded,
//                               color: Color(0xff2965B0),
//                             ),
//                             SizedBox(
//                               width: 10.w,
//                             ),
//                             Text(
//                               'Get a Solicitor',
//                               style: TextStyle(
//                                   color: Color(0xff2965B0),
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 11.sp,
//                                   height: 1.2,
//                                   letterSpacing: 0.1),
//                             ),
//                           ],
//                         ),
//                         onTap: () {},
//                       ),
//                     ],
//                   ),
//                 ),
//                 builder: (_, collapsed, expanded) {
//                   return Expandable(
//                     collapsed: collapsed,
//                     expanded: expanded,
//                     theme: const ExpandableThemeData(crossFadePoint: 0),
//                   );
//                 },
//                 collapsed: Text(""),
//               ),
//             )),
//             ExpandableNotifier(
//                 child: ScrollOnExpand(
//               scrollOnExpand: true,
//               scrollOnCollapse: false,
//               child: ExpandablePanel(
//                 theme: const ExpandableThemeData(
//                     hasIcon: false,
//                     iconColor: Colors.black,
//                     headerAlignment: ExpandablePanelHeaderAlignment.center,
//                     tapBodyToCollapse: false,
//                     iconPadding: EdgeInsets.zero),
//                 header: Container(
//                   height: 30.h,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: EdgeInsets.only(left: 8.w, right: 10.w),
//                         child: Text(
//                           "Account & Support",
//                           style: TextStyle(
//                             color: Color(0xff535763),
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12.sp,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 3,
//                         ),
//                       ),
//                       SizedBox(
//                           width: 30.w,
//                           child: Icon(CupertinoIcons.chevron_down,
//                               size: 12.w, color: Color(0xff535763)))
//                     ],
//                   ),
//                 ),
//                 expanded: Container(
//                     margin: EdgeInsets.only(left: 8.w, top: 5.h, bottom: 15.h),
//                     padding:
//                         EdgeInsets.symmetric(vertical: 6.h, horizontal: 15.w),
//                     child: Column(
//                       children: [
//                         GestureDetector(
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.account_circle_outlined,
//                                 size: 20.sp,
//                                 color: Color(0xff2965B0),
//                               ),
//                               SizedBox(
//                                 width: 10.w,
//                               ),
//                               Text(
//                                 'Account Details',
//                                 style: TextStyle(
//                                     color: Color(0xff2965B0),
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 11.sp,
//                                     height: 1.2,
//                                     letterSpacing: 0.1),
//                               ),
//                             ],
//                           ),
//                           onTap: () {},
//                         ),
//                         SizedBox(
//                           height: 14.h,
//                         ),
//                         GestureDetector(
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.person_outline_rounded,
//                                 size: 20.sp,
//                                 color: Color(0xff2965B0),
//                               ),
//                               SizedBox(
//                                 width: 10.w,
//                               ),
//                               Text(
//                                 'Personal Details',
//                                 style: TextStyle(
//                                     color: Color(0xff2965B0),
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 11.sp,
//                                     height: 1.2,
//                                     letterSpacing: 0.1),
//                               ),
//                             ],
//                           ),
//                           onTap: () {},
//                         ),
//                         SizedBox(
//                           height: 14.h,
//                         ),
//                         GestureDetector(
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.help_outline_rounded,
//                                 size: 20.sp,
//                                 color: Color(0xff2965B0),
//                               ),
//                               SizedBox(
//                                 width: 10.w,
//                               ),
//                               Text(
//                                 'Help & Sepport',
//                                 style: TextStyle(
//                                     color: Color(0xff2965B0),
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 11.sp,
//                                     height: 1.2,
//                                     letterSpacing: 0.1),
//                               ),
//                             ],
//                           ),
//                           onTap: () {},
//                         ),
//                         SizedBox(
//                           height: 14.h,
//                         ),
//                         GestureDetector(
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.feedback_outlined,
//                                 size: 20.sp,
//                                 color: Color(0xff2965B0),
//                               ),
//                               SizedBox(
//                                 width: 10.w,
//                               ),
//                               Text(
//                                 'Feedback',
//                                 style: TextStyle(
//                                     color: Color(0xff2965B0),
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 11.sp,
//                                     height: 1.2,
//                                     letterSpacing: 0.1),
//                               ),
//                             ],
//                           ),
//                           onTap: () {},
//                         ),
//                         SizedBox(
//                           height: 14.h,
//                         ),
//                         GestureDetector(
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.logout_rounded,
//                                 size: 20.sp,
//                                 color: Color(0xff2965B0),
//                               ),
//                               SizedBox(
//                                 width: 10.w,
//                               ),
//                               Text(
//                                 'Logout',
//                                 style: TextStyle(
//                                     color: Color(0xff2965B0),
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 11.sp,
//                                     height: 1.2,
//                                     letterSpacing: 0.1),
//                               ),
//                             ],
//                           ),
//                           onTap: () {},
//                         ),
//                       ],
//                     )),
//                 builder: (_, collapsed, expanded) {
//                   return Expandable(
//                     collapsed: collapsed,
//                     expanded: expanded,
//                     theme: const ExpandableThemeData(crossFadePoint: 0),
//                   );
//                 },
//                 collapsed: Text(""),
//               ),
//             )),
//           ],
//         ),
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '/teacher/home/explore/student/user_batch_screen.dart';
import '/widgets/headline.dart';
import '../../../models/profile_data.dart';
import 'about/about.dart';
import 'cr/cr.dart';
import 'staff/staff.dart';
import 'student/all_student_screen.dart';
import 'teacher/teacher.dart';
import 'university/university.dart';

class Explore extends StatelessWidget {
  const Explore({
    Key? key,
    required this.profileData,
  }) : super(key: key);

  final ProfileData profileData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 800
            ? MediaQuery.of(context).size.width * .2
            : 16,
      ),
      child: Column(
        children: [
          //category title
          const Headline(title: 'Explore'),

          //explore card grid
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // university
                GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      University.routeName,
                      arguments: {
                        'profileData': profileData,
                      },
                    );
                  },
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // title, name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //title
                              Text(
                                'University'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),

                              const SizedBox(height: 4),

                              // uni name
                              Text(profileData.university.toUpperCase())
                            ],
                          ),

                          const SizedBox(width: 8),

                          //image
                          Image.asset(
                            'assets/categories/fly.png',
                            height: 32,
                            width: 32,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // about, teacher
                Row(
                  children: [
                    // dept
                    Expanded(
                      flex: 50,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            About.routeName,
                            arguments: {
                              'profileData': profileData,
                            },
                          );
                        },
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            height: 160,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // image
                                Flexible(
                                  child: Image.asset(
                                    'assets/categories/department.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                //dept
                                Text(
                                  'About\nDepartment'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // teacher
                    Expanded(
                      flex: 60,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            Teacher.routeName,
                            arguments: {
                              'profileData': profileData,
                            },
                          );
                        },
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            height: 160,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // image
                                Flexible(
                                  child: Image.asset(
                                    'assets/categories/teacher.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                //teacher
                                Text(
                                  'Teacher\nInformation'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // student
                GestureDetector(
                  onTap: () {
                    if (profileData.information.batch != '') {
                      Get.to(
                        () => UserBatchScreen(profileData: profileData),
                      );
                    } else {
                      Get.toNamed(
                        AllStudentScreen.routeName,
                        arguments: {
                          'profileData': profileData,
                        },
                      );
                    }
                  },
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Container(
                      height: 160,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //std, dot
                          Column(
                            children: [
                              //
                              Text(
                                'Student\nInformation'.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),

                          const SizedBox(width: 8),

                          // image
                          Flexible(
                            child: Image.asset(
                              'assets/categories/student.png',
                              fit: BoxFit.cover,
                              // height: 130,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // cr, staff
                Row(
                  children: [
                    // cr
                    Expanded(
                      flex: 70,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            Cr.routeName,
                            arguments: {
                              'profileData': profileData,
                            },
                          );
                        },
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            height: 160,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // image
                                Flexible(
                                  child: Image.asset(
                                    'assets/categories/cr.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                //cr
                                Text(
                                  'Class\nRepresentative'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // staff
                    Expanded(
                      flex: 50,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            Staff.routeName,
                            arguments: {
                              'profileData': profileData,
                            },
                          );
                        },
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Container(
                            height: 160,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // image
                                Flexible(
                                  child: Image.asset(
                                    'assets/categories/staff.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                //staff
                                Text(
                                  'Office\nStaff'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

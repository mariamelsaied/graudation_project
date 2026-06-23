import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/cubit/auth_cubit.dart';
import 'package:graduation_app/cubit/auth_state.dart';
import 'package:graduation_app/cubit/profile_cubit.dart';
import 'package:graduation_app/cubit/profile_state.dart';
import 'package:graduation_app/models/user_model.dart';
import 'package:graduation_app/widgets/side_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().getUserProfile();

    return Scaffold(
      backgroundColor: ColorsApp.darknavyblueColor,
      drawer: const SideMenu(currentPage: "My Profile"),
      appBar: AppBar(
        backgroundColor: ColorsApp.darknavyblueColor,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu, color: ColorsApp.WhiteColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            color: ColorsApp.WhiteColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 1.0, right: 2.0),
            child: Badge(
              isLabelVisible: true,
              backgroundColor: ColorsApp.redColor,
              smallSize: 9,
              alignment: AlignmentDirectional(0.5, -0.5),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: ColorsApp.WhiteColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/notification');
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: BlocBuilder<LoginCubit, AuthState>(
              builder: (context, state) {
                String? avatarUrl;
                if (state is AuthSuccess) {
                  avatarUrl = state.loginResponse.data?.user?.general?.avatar;
                }

                return CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[800],
                  backgroundImage:
                      (avatarUrl != null && avatarUrl.isNotEmpty)
                          ? NetworkImage(avatarUrl)
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is GetProfileLoadingState &&
                context.read<ProfileCubit>().currentUserModel == null) {
              return Center(
                child: CircularProgressIndicator(color: ColorsApp.blueColor),
              );
            }
            if (state is GetProfileErrorState &&
                context.read<ProfileCubit>().currentUserModel == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: ColorsApp.pinkColor,
                        size: 60,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        state.errorMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorsApp.greyColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsApp.blueColor,
                        ),
                        onPressed:
                            () => context.read<ProfileCubit>().getUserProfile(),
                        child: Text(
                          'Retry',
                          style: TextStyle(color: ColorsApp.WhiteColor),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            final user =
                context.read<ProfileCubit>().currentUserModel?.data?.user;

            if (user == null) {
              return Center(
                child: Text(
                  'No user data available.',
                  style: TextStyle(color: ColorsApp.WhiteColor),
                ),
              );
            }
            return _buildProfileBody(context, user);
          },
        ),
      ),
    );
  }

  Widget _buildProfileBody(BuildContext context, UserDetails user) {
    final general = user.general;
    final employee = user.employee;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            color: ColorsApp.secondaryBlueColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: ColorsApp.secondaryBlueColor.withOpacity(0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: ColorsApp.blueColor.withOpacity(0.1),
                    backgroundImage:
                        general.avatar.isNotEmpty
                            ? NetworkImage(general.avatar)
                            : null,
                    child:
                        general.avatar.isEmpty
                            ? Icon(
                              Icons.person,
                              size: 50,
                              color: ColorsApp.blueColor,
                            )
                            : null,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${general.firstName} ${general.lastName}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ColorsApp.WhiteColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    general.role.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorsApp.blueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          _buildSectionTitle('Personal Information', Icons.person_outline),
          Card(
            color: ColorsApp.secondaryBlueColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildInfoTile(Icons.email, 'Email Address', general.email),
                _buildInfoTile(Icons.phone, 'Phone Number', general.phone),
                _buildInfoTile(Icons.location_on, 'Address', general.address),
                _buildInfoTile(Icons.wc, 'Gender', general.gender),
                _buildInfoTile(Icons.qr_code, 'RFID Tag', general.rfidTag),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (employee != null) ...[
            _buildSectionTitle('Employment Details', Icons.work_outline),
            Card(
              color: ColorsApp.secondaryBlueColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoTile(Icons.badge, 'Job Title', employee.jobTitle),
                  _buildInfoTile(
                    Icons.business,
                    'Department',
                    employee.department,
                  ),
                  _buildInfoTile(
                    Icons.place,
                    'Work Location',
                    employee.workLocation,
                  ),
                  _buildInfoTile(
                    Icons.assignment,
                    'Employment Type',
                    employee.jobType,
                  ),
                  _buildInfoTile(
                    Icons.attach_money,
                    'Base Salary',
                    '\$${employee.baseSalary}',
                  ),
                  _buildInfoTile(
                    Icons.access_time,
                    'Working Hours',
                    '${employee.workingHours} hrs/week',
                  ),
                  _buildInfoTile(Icons.info, 'Status', employee.status),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Leave Balance', Icons.calendar_today),
            Card(
              color: ColorsApp.secondaryBlueColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLeaveItem(
                      'Annual',
                      employee.leaveBalance.annual,
                      ColorsApp.blueColor,
                    ),
                    _buildLeaveItem(
                      'Sick',
                      employee.leaveBalance.sick,
                      ColorsApp.pinkColor,
                    ),
                    _buildLeaveItem(
                      'Casual',
                      employee.leaveBalance.casual,
                      ColorsApp.orangeColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        children: [
          Icon(icon, color: ColorsApp.blueColor, size: 22),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorsApp.blueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: ColorsApp.greyColor),
      title: Text(
        label,
        style: TextStyle(fontSize: 12, color: ColorsApp.greyColor),
      ),
      subtitle: Text(
        value.isNotEmpty ? value : 'Not Specified',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: ColorsApp.WhiteColor,
        ),
      ),
    );
  }

  Widget _buildLeaveItem(String title, int count, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: color.withOpacity(0.12),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: ColorsApp.WhiteColor,
          ),
        ),
      ],
    );
  }
}

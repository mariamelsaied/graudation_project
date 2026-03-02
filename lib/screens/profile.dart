import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsApp.blackColor,
        elevation: 0,
        leading: Icon(Icons.menu, color: ColorsApp.WhiteColor),
        title: Text(
          "My Profile",
          style: TextStyle(color: ColorsApp.WhiteColor),
        ),
        actions: [
          Icon(Icons.notifications_none, color: ColorsApp.WhiteColor),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/user.png'),
            ),
          ),
        ],
      ),
     
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(), 
            const SizedBox(height: 20),
            _buildTabBar(), 
            const SizedBox(height: 10),
            _buildPersonalInfoCard(),
            _buildContactDetailsCard(),
            _buildAddressCard(), 
            _buildEmploymentCard(), 
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none, 
          children: [
      
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorsApp.darknavyblueColor, ColorsApp.pimaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
         
            Positioned(
              bottom: -50,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor:
                        ColorsApp.blackColor,
                    child: const CircleAvatar(
                      radius: 56,
                      backgroundImage: AssetImage(
                        'assets/alex.jpg',
                      ), 
                    ),
                  ),
                
                  Positioned(
                    bottom: 10,
                    right: 5,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: ColorsApp.greenColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorsApp.blackColor,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 60), 
       
        Text(
          "Alex Johnson",
          style: TextStyle(
            color: ColorsApp.WhiteColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Senior Product Designer",
          style: TextStyle(
            color: ColorsApp.blueColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),

     
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeaderChip(Icons.badge_outlined, "#EMP-2023-045"),
            const SizedBox(width: 12),
            _buildHeaderChip(Icons.location_on_outlined, "San Francisco, CA"),
          ],
        ),
        const SizedBox(height: 25),

     
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ElevatedButton.icon(
            onPressed: () {
            },
            icon: Icon(Icons.edit, color: ColorsApp.WhiteColor, size: 18),
            label: Text(
              "Edit Profile",
              style: TextStyle(
                color: ColorsApp.WhiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsApp.blueColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: ColorsApp.blackColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: ColorsApp.greyColor, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: ColorsApp.greyColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. الـ Tab Bar ---
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _tabItem("Personal", isActive: true),
          _tabItem("Job"),
          _tabItem("Documents"),
          _tabItem("Emergency"),
        ],
      ),
    );
  }

  Widget _tabItem(String title, {bool isActive = false}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: isActive ? ColorsApp.blueColor : ColorsApp.greyColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 40,
            color: ColorsApp.blueColor,
          ),
      ],
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20), // مسافة داخلية واسعة زي الصورة
      decoration: BoxDecoration(
        color: ColorsApp.darknavyblueColor, // خلفية الكارت الداكنة
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // السطر العلوي: العنوان وأيقونة التعديل
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Personal Information",
                style: TextStyle(
                  color: ColorsApp.WhiteColor, // حرف W كبير زي ملفك
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.edit_outlined, color: ColorsApp.greyColor, size: 20),
            ],
          ),
          const SizedBox(height: 25), // مسافة تحت العنوان
          // سطر الاسم الكامل
          _buildInfoItem("FULL NAME", "Alex James Johnson"),
          const SizedBox(height: 20),

          // سطر تاريخ الميلاد والنوع (بجانب بعض)
          Row(
            children: [
              Expanded(
                child: _buildInfoItem("DATE OF BIRTH", "October 24, 1990"),
              ),
              Expanded(child: _buildInfoItem("GENDER", "Male")),
            ],
          ),
          const SizedBox(height: 20),

          // سطر الجنسية
          _buildInfoItem("NATIONALITY", "American"),
          const SizedBox(height: 20),

          // سطر الحالة الاجتماعية والـ SSN
          Row(
            children: [
              Expanded(child: _buildInfoItem("MARITAL STATUS", "Single")),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SSN (LAST 4)",
                      style: TextStyle(
                        color: ColorsApp.greyColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          "****-**-6789",
                          style: TextStyle(
                            color: ColorsApp.WhiteColor,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.lock_outline,
                          color: ColorsApp.greyColor,
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ويدجت صغيرة عشان نكرر فيها تنسيق كل بيان (Label + Value)
  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: ColorsApp.greyColor, // اللون الرمادي للعنوان الصغير
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: ColorsApp.WhiteColor, // اللون الأبيض للقيمة
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // --- 4. كارت بيانات الاتصال ---
  Widget _buildContactDetailsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20), // مسافة داخلية واسعة زي الصورة
      decoration: BoxDecoration(
        color: ColorsApp.darknavyblueColor, // خلفية الكارت الداكنة
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // السطر العلوي: العنوان وأيقونة التعديل
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Contact Details",
                style: TextStyle(
                  color: ColorsApp.WhiteColor, // حرف W كبير زي ملفك
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.edit_outlined, color: ColorsApp.greyColor, size: 20),
            ],
          ),
          const SizedBox(height: 25), // مسافة تحت العنوان
          // قائمة بيانات الاتصال بالأيقونات
          _buildContactItem(
            Icons.email,
            "WORK EMAIL",
            "alex.johnson@company.com",
            isFirst: true,
          ),
          _buildContactItem(
            Icons.mail_outline,
            "PERSONAL EMAIL",
            "alex.j.design@gmail.com",
          ),
          _buildContactItem(Icons.phone, "PHONE NUMBER", "+1 (555) 123-4567"),
          _buildContactItem(
            Icons.smartphone,
            "WORK MOBILE",
            "Not provided",
            isLast: true,
          ),
        ],
      ),
    );
  }

  // ويدجت لتنسيق كل سطر (الأيقونة + النصوص)
  Widget _buildContactItem(
    IconData icon,
    String label,
    String value, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        children: [
          // بوكس الأيقونة الملون
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorsApp.blackColor.withOpacity(
                0.3,
              ), // خلفية أغمق قليلاً للأيقونة
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: ColorsApp.blueColor, size: 22),
          ),
          const SizedBox(width: 15),
          // النصوص (العنوان والقيمة)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: ColorsApp.greyColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color:
                      value == "Not provided"
                          ? ColorsApp.greyColor
                          : ColorsApp.WhiteColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- 5. كارت العنوان ---
  Widget _buildAddressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20), // مسافة داخلية واسعة متناسقة
      decoration: BoxDecoration(
        color: ColorsApp.darknavyblueColor, // لون الكارت الداكن
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // السطر العلوي: العنوان وأيقونة التعديل
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Address",
                style: TextStyle(
                  color: ColorsApp.WhiteColor, // حرف W كبير
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.edit_outlined, color: ColorsApp.greyColor, size: 20),
            ],
          ),
          const SizedBox(height: 25), // مسافة تحت العنوان
          // عنوان البيانات الصغير (Label)
          Text(
            "CURRENT RESIDENTIAL ADDRESS",
            style: TextStyle(
              color: ColorsApp.greyColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),

          // نص العنوان (Value)
          Text(
            "123 Innovation Drive, Apt 4B\nSan Francisco, CA 94103\nUnited States",
            style: TextStyle(
              color: ColorsApp.WhiteColor,
              fontSize: 15,
              height: 1.5, // مسافة بين الأسطر عشان يظهر بوضوح
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),

          // نوع العنوان (Address Type Label)
          Text(
            "ADDRESS TYPE",
            style: TextStyle(
              color: ColorsApp.greyColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // البوكس الصغير (Primary Residence Tag)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ColorsApp.blackColor.withOpacity(0.4), // خلفية أغمق للتاج
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white10), // إطار خفيف جداً
            ),
            child: Text(
              "Primary Residence",
              style: TextStyle(
                color: ColorsApp.greyColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 6. كارت التوظيف ---
  Widget _buildEmploymentCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20), // نفس المسافات الواسعة المنظمة
      decoration: BoxDecoration(
        color: ColorsApp.darknavyblueColor, // لون الكارت من ملفك
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان الكارت الأساسي
          Text(
            "Employment",
            style: TextStyle(
              color: ColorsApp.WhiteColor, // حرف W كبير
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),

          // قسم القسم (Department)
          Text(
            "DEPARTMENT",
            style: TextStyle(
              color: ColorsApp.greyColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.circle,
                color: ColorsApp.blueColor,
                size: 10,
              ), // النقطة الزرقاء
              const SizedBox(width: 8),
              Text(
                "Product & Design",
                style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // قسم المدير (Reporting To)
          Text(
            "REPORTING TO",
            style: TextStyle(
              color: ColorsApp.greyColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorsApp.blackColor.withOpacity(
                0.3,
              ), // خلفية أغمق للبروفايل
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                    'assets/sarah.jpg',
                  ), // صورة سارة ميلر
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sarah Miller",
                      style: TextStyle(
                        color: ColorsApp.WhiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "VP of Product",
                      style: TextStyle(
                        color: ColorsApp.greyColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // تفاصيل العقد (Date & Contract)
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DATE JOINED",
                      style: TextStyle(
                        color: ColorsApp.greyColor,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Aug 15, 2021",
                      style: TextStyle(
                        color: ColorsApp.WhiteColor,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CONTRACT",
                      style: TextStyle(
                        color: ColorsApp.greyColor,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // بوكس الحالة (Full-Time Tag)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorsApp.darkgreenColor.withOpacity(
                          0.2,
                        ), // الأخضر الغامق من ملفك
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "Full-Time",
                        style: TextStyle(
                          color: ColorsApp.greenColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

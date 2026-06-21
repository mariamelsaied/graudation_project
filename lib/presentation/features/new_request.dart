import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/cubit/request_cubit.dart';
import 'package:graduation_app/cubit/request_state.dart';

class NewRequestScreen extends StatefulWidget {
  final dynamic request; // استقبال الطلب في حالة التعديل (Null في حالة الطلب الجديد)

  const NewRequestScreen({super.key, this.request});

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  String? _selectedType; 
  String? _selectedPriority; 
  PlatformFile? _selectedFile;
  
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  bool get isEditMode => widget.request != null; // متغير يحدد هل نحن في وضع التعديل أم لا

  final InputDecoration _inputDecoration = InputDecoration(
    filled: true,
    fillColor: const Color(0xFF111622),
    hintStyle: const TextStyle(color: Color(0xFF475569), fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF1E293B), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF1E293B), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.blue, width: 1.5),
    ),
  );

  @override
  void initState() {
    super.initState();
    // إذا كنا في وضع التعديل، نقوم بملء الحقول بالبيانات القادمة
    if (isEditMode) {
      _subjectController.text = widget.request.title ?? '';
      _descriptionController.text = widget.request.description ?? '';
      _selectedPriority = widget.request.priority;
      
      // تأكد من تطابق المسميات القادمة من السيرفر مع العناصر الموجودة في الـ Dropdown لـ Request Type
      _selectedType = widget.request.type; 
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      setState(() => _selectedFile = result.files.single);
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Color(0xFF111622),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.darknavyblueColor,
      appBar: AppBar(
        backgroundColor: ColorsApp.darknavyblueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditMode ? "Edit Request" : "New Request", 
          style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<RequestCubit, RequestState>(
        listener: (context, state) {
          // 1. معالجة حالة إنشاء طلب جديد
          if (state is CreateRequestSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Request Created Successfully!")));
            Navigator.pop(context, true);
          } else if (state is CreateRequestErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
          
          // 2. 💡 معالجة حالة تعديل طلب موجود (تحديث)
          if (state is UpdateRequestSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Request Updated Successfully!")));
            Navigator.pop(context, true); // العودة للخلف وتحديث القائمة
          } else if (state is UpdateRequestErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          // فحص إذا كان التطبيق في حالة تحميل (سواء إنشاء أو تعديل) لتعطيل الزر وعرض الـ Indicator
          final bool isLoading = state is CreateRequestLoadingState || state is UpdateRequestLoadingState;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. نوع الطلب (Request Type Dropdown)
                const Text("Request Type", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  dropdownColor: const Color(0xFF161D2D), 
                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  hint: const Text("Select type...", style: TextStyle(color: Color(0xFF475569), fontSize: 14)),
                  items: ["HR Letter", "Payroll Inquiry", "Complaint", "IT Support", "Other"]
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type, style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedType = val),
                  decoration: _inputDecoration,
                ),
                const SizedBox(height: 18),

                // 2. مستوى الأهمية (Priority Dropdown)
                const Text("Priority", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  dropdownColor: const Color(0xFF161D2D), 
                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  hint: const Text("Select priority...", style: TextStyle(color: Color(0xFF475569), fontSize: 14)),
                  items: ["Low", "Medium", "High"]
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority, style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedPriority = val),
                  decoration: _inputDecoration,
                ),
                const SizedBox(height: 18),
                
                // 3. العنوان
                const Text("Subject", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextField(
                  controller: _subjectController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration.copyWith(hintText: "Enter subject..."),
                ),
                const SizedBox(height: 18),

                // 4. قسم التاريخ
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Start Date", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _startDateController,
                            readOnly: true,
                            style: const TextStyle(color: Colors.white),
                            onTap: () => _selectDate(context, _startDateController),
                            decoration: _inputDecoration.copyWith(
                              hintText: "mm/dd/yyyy",
                              suffixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF64748B), size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("End Date", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _endDateController,
                            readOnly: true,
                            style: const TextStyle(color: Colors.white),
                            onTap: () => _selectDate(context, _endDateController),
                            decoration: _inputDecoration.copyWith(
                              hintText: "mm/dd/yyyy",
                              suffixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF64748B), size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                
                // 5. الوصف
                const Text("Description", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration.copyWith(hintText: "Describe your request..."),
                  maxLines: 4,
                ),
                const SizedBox(height: 18),
                
                // 6. المرفقات
                const Text("Attachments", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111622),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 1.5,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.cloud_upload_outlined, color: Colors.blue, size: 32),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _selectedFile == null ? "Tap to upload files" : _selectedFile!.name,
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        const Text("PDF, JPG, PNG (Max 5MB)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 35),
                
                // 7. الأزرار السفلية (Cancel & Submit)
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF1E293B)),
                            backgroundColor: const Color(0xFF1E293B).withOpacity(0.4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0091FF), 
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: isLoading ? null : () {
                            if (_selectedType == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please select a request type first")),
                              );
                              return;
                            }
                            
                            if (_selectedPriority == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please select a priority level first")),
                              );
                              return;
                            }

                            if (isEditMode) {
                              // ========================================================
                              // 💡 تفعيل واستدعاء دالة التعديل الحقيقية من الـ Cubit
                              // ========================================================
                              context.read<RequestCubit>().updateRequest(
                                    requestId: widget.request.id!, // تمرير الـ id الخاص بالطلب الحالي بشرط ألا يكون null
                                    type: _selectedType!,
                                    title: _subjectController.text,
                                    description: _descriptionController.text,
                                    priority: _selectedPriority!,
                                    attachmentFile: _selectedFile != null ? _selectedFile : null, 
                                  );
                            } else {
                              // دالة الإنشاء العادية (Create)
                              context.read<RequestCubit>().createRequest(
                                type: _selectedType!,
                                title: _subjectController.text,
                                description: _descriptionController.text,
                                priority: _selectedPriority!, 
                                filePath: _selectedFile?.path,
                              );
                            }
                          },
                          child: isLoading 
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : Text(
                                isEditMode ? "Update Request" : "Submit Request", 
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
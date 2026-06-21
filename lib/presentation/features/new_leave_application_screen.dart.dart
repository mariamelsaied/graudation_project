import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/cubit/leave_cubit.dart';
import 'package:graduation_app/cubit/leave_state.dart'; 
import 'package:graduation_app/widgets/leave_type_dropdown.dart';
import 'package:graduation_app/widgets/custom_date_picker.dart';
import 'package:graduation_app/widgets/file_upload_area.dart';

class NewLeaveApplicationScreen extends StatefulWidget {
  final dynamic leaveItem;

  const NewLeaveApplicationScreen({super.key, this.leaveItem});

  @override
  State<NewLeaveApplicationScreen> createState() => _NewLeaveApplicationScreenState();
}

class _NewLeaveApplicationScreenState extends State<NewLeaveApplicationScreen> {
  String? selectedLeaveType;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  
  String? pickedFileName;
  String? pickedFilePath;

  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.leaveItem != null) {
      isEditMode = true;
      
      selectedLeaveType = widget.leaveItem.type;
      startDateController.text = _formatIncomingDate(widget.leaveItem.startDate);
      endDateController.text = _formatIncomingDate(widget.leaveItem.endDate);
      reasonController.text = widget.leaveItem.reason ?? '';
      try {
        if (widget.leaveItem.attachment != null) {
          pickedFileName = widget.leaveItem.attachment.toString().split('/').last;
        }
      } catch (_) {
        pickedFileName = null;
      }
    }
  }

  String _formatIncomingDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(isoDate);
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return isoDate.split('T')[0];
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'png', 'svg'], 
      );

      if (result != null) {
        setState(() {
          pickedFileName = result.files.single.name;
          pickedFilePath = result.files.single.path;
        });
      }
    } catch (e) {
      debugPrint("خطأ أثناء اختيار الملف: $e");
    }
  }

  bool _validateForm() {
    if (selectedLeaveType == null) {
      _showSnackBar("Please select a Leave Type");
      return false;
    }
    if (startDateController.text.isEmpty) {
      _showSnackBar("Please select a Start Date");
      return false;
    }
    if (endDateController.text.isEmpty) {
      _showSnackBar("Please select an End Date");
      return false;
    }
    if (reasonController.text.isEmpty) {
      _showSnackBar("Please provide a reason for your leave");
      return false;
    }
    return true;
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.darknavyblueColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditMode ? "Update Application" : "New Application",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditMode ? "Update Leave Application" : "New Leave Application",
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isEditMode 
                  ? "Modify the fields below to update your pending leave request."
                  : "Fill out the form below to request time off. All requests are subject to approval.",
              style: TextStyle(color: ColorsApp.greyColor.withOpacity(0.8), fontSize: 14),
            ),
            const SizedBox(height: 24),

            _buildSectionCard(
              title: "Leave Details",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Leave Type"),
                  LeaveTypeDropdown(
                    value: selectedLeaveType,
                    onChanged: (val) => setState(() => selectedLeaveType = val),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel("Start Date"),
                  CustomDatePicker(controller: startDateController, hint: "mm/dd/yyyy"),
                  const SizedBox(height: 16),
                  _buildLabel("End Date"),
                  CustomDatePicker(controller: endDateController, hint: "mm/dd/yyyy"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionCard(
              title: "Reason & Attachments",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Reason for Leave"),
                  _buildTextArea(),
                  const SizedBox(height: 20),
                  _buildLabel("Attachments (Optional)"),
                  FileUploadArea(pickedFileName: pickedFileName, onTap: pickFile), 
                ],
              ),
            ),

            const SizedBox(height: 30),

            BlocConsumer<LeaveCubit, LeaveState>(
              listener: (context, state) {
                if (state is LeaveSubmitSuccessState) {
                  _showSnackBar(state.message, isError: false);
                  LeaveCubit.get(context).getLeaves(page: 1, status: 'All');
                  Navigator.pop(context);
                } 
                else if (state is LeaveUpdateSuccessState) {
                  _showSnackBar(state.message, isError: false);
                  LeaveCubit.get(context).getLeaves(page: 1, status: 'All');
                  LeaveCubit.get(context).getYearlyChart(year: DateTime.now().year);
                  LeaveCubit.get(context).getLeaveBalance();
                  
                  Navigator.pop(context); 
                } 
                else if (state is LeaveSubmitErrorState) {
                  _showSnackBar(state.message);
                } else if (state is LeaveUpdateErrorState) {
                  _showSnackBar(state.message);
                }
              },
              builder: (context, state) {
                if (state is LeaveSubmitLoadingState || state is LeaveUpdateLoadingState) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF2D62ED)));
                }

                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D62ED),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_validateForm()) {
                      if (isEditMode) {
                        final String leaveId = widget.leaveItem.id ?? widget.leaveItem.sId ?? '';
                        LeaveCubit.get(context).updateLeaveApplication(
                          id: leaveId,
                          type: selectedLeaveType!,
                          startDate: startDateController.text,
                          endDate: endDateController.text,
                          reason: reasonController.text,
                          filePath: pickedFilePath,
                        );
                      } else {
                        LeaveCubit.get(context).submitLeaveApplication(
                          type: selectedLeaveType!,
                          startDate: startDateController.text,
                          endDate: endDateController.text,
                          reason: reasonController.text,
                          filePath: pickedFilePath,
                        );
                      }
                    }
                  },
                  icon: Icon(isEditMode ? Icons.edit : Icons.send, color: Colors.white, size: 18),
                  label: Text(
                    isEditMode ? "Update Application" : "Submit Application", 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            if (!isEditMode)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    selectedLeaveType = null;
                    startDateController.clear();
                    endDateController.clear();
                    reasonController.clear();
                    pickedFileName = null;
                    pickedFilePath = null;
                  });
                },
                icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                label: const Text("Reset", style: TextStyle(color: Colors.white)),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2235),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Divider(color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          children: const [
            TextSpan(text: " *", style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextArea() {
    return TextField(
      controller: reasonController,
      maxLines: 4,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Please describe the reason for your leave request...",
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        fillColor: const Color(0xFF0D121F),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
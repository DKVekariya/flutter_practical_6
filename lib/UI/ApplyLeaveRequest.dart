import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Data/Models/LeaveData.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  _LeaveRequestScreenState createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field variables
  LeaveType? _selectedLeaveType =
      LeaveType.casual; // Default leave type to casual
  String? _leaveReason;
  DateTime? _leaveStartDate;
  DateTime? _leaveEndDate;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  // Method to open date picker and get date
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _leaveStartDate = pickedDate;

        // Automatically set leave type to urgent if start date is within 3 days from now
        if (_leaveEndDate != null &&
            _leaveStartDate!.difference(_leaveEndDate!).inDays < 3) {
          _selectedLeaveType = LeaveType.urgent;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _leaveEndDate = pickedDate;
        // Automatically set leave type to urgent if start date is within 3 days from now
        if (_leaveStartDate != null &&
            _leaveStartDate!.difference(_leaveEndDate!).inDays < 3) {
          _selectedLeaveType = LeaveType.urgent;
        }
      });
    }
  }

  // Method to format date for display
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Method to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create the LeaveData object with the form inputs
      LeaveData leaveData = LeaveData(
        isApproved: false,
        // Default for a new leave request
        leaveType: _selectedLeaveType!,
        leaveStatus: LeaveStatus.pending,
        leaveReason: _leaveReason!,
        leaveStartDate: _formatDate(_leaveStartDate),
        leaveEndDate: _formatDate(_leaveEndDate),
        leaveAppliedDate: _formatDate(DateTime.now()),
      );

      Navigator.pop(context, leaveData);
      // You can now use the leaveData object (e.g., send to backend)
      print(leaveData); // For testing
    }
  }

  @override
  void dispose() {
    super.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Leave'), // Updated title here
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Dropdown for leave type
              DropdownButtonFormField<LeaveType>(
                decoration: const InputDecoration(labelText: 'Leave Type'),
                value: _selectedLeaveType,
                items: LeaveType.values.map((LeaveType type) {
                  return DropdownMenuItem<LeaveType>(
                    value: type,
                    child: Text(type.toString().split('.').last.toUpperCase()),
                  );
                }).toList(),
                onChanged: (LeaveType? newValue) {
                  setState(() {
                    _selectedLeaveType = newValue!;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a leave type' : null,
              ),

              // Text input for leave reason
              TextFormField(
                decoration: const InputDecoration(labelText: 'Leave Reason'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reason for leave';
                  } else if (value.length < 3) {
                    return 'Reason must be at least 3 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  _leaveReason = value;
                },
              ),

              // Date picker for leave start date

              InkWell(
                onTap: () {
                  _selectStartDate(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _leaveStartDate == null
                        ? 'Leave Start Date'
                        : _formatDate(_leaveStartDate),
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              InkWell(
                onTap: () {
                  _selectEndDate(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _leaveEndDate == null
                        ? 'Leave End Date'
                        : _formatDate(_leaveEndDate),
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Apply'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

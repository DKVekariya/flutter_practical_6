class LeaveData {
  bool isApproved;
  LeaveType leaveType;
  LeaveStatus leaveStatus;
  String leaveReason;
  String leaveStartDate;
  String leaveEndDate;
  String leaveAppliedDate;

  LeaveData(
      {required this.isApproved,
      required this.leaveType,
      required this.leaveStatus,
      required this.leaveReason,
      required this.leaveStartDate,
      required this.leaveEndDate,
      required this.leaveAppliedDate});

  Map<String, dynamic> toMap() {
    return {
      'isApproved': isApproved ? 1 : 0,
      'leaveType': leaveType,
      'leaveStatus': leaveStatus,
      'leaveReason': leaveReason,
      'leaveStartDate': leaveStartDate,
      'leaveEndDate': leaveEndDate,
      'leaveAppliedDate': leaveAppliedDate
    };
  }

  @override
  String toString() {
    return 'LeaveData{'
        'isApproved: $isApproved, '
        'leaveType: $leaveType, '
        'leaveStatus: $leaveStatus, '
        'leaveReason: $leaveReason, '
        'leaveStartDate: $leaveStartDate, '
        'leaveEndDate: $leaveEndDate, '
        'leaveAppliedDate: $leaveAppliedDate'
        '}';
  }
}

enum LeaveType { casual, sick, personal, urgent, early, other }

enum LeaveStatus { pending, approved, rejected }

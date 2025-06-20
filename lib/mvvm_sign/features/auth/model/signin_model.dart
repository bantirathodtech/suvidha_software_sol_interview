class Welcome {
  final bool status;
  final List<Datum> data;

  Welcome({required this.status, required this.data});

  factory Welcome.fromJson(Map<String, dynamic> json) {
    return Welcome(
      status: json['status'] ?? false,
      data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  final String id;
  final String personName;
  final String email;
  final String mobileNumber;
  final String locationId;
  final String role;
  final String profileImage;
  final String branchId;
  final String financialYearId;

  Datum({
    required this.id,
    required this.personName,
    required this.email,
    required this.mobileNumber,
    required this.locationId,
    required this.role,
    required this.profileImage,
    required this.branchId,
    required this.financialYearId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json['id'] ?? '',
      personName: json['person_name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      locationId: json['location_id'] ?? '',
      role: json['role'] ?? '',
      profileImage: json['profile_image'] ?? '',
      branchId: json['branch_id'] ?? '',
      financialYearId: json['financial_year_id'] ?? '',
    );
  }
}

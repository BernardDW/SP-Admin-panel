class UserCard {
  String userid;
  String useremail;
  String status;
  String businessname;
  String latitude;
  String longitude;
  String referenceNo;
  String specialslimit;

  UserCard(this.userid, this.useremail, this.status, this.businessname,
      this.latitude, this.longitude, this.referenceNo, this.specialslimit);

  UserCard.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    useremail = json['useremail'];
    status = json['status'];
    businessname = json['businessname'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    referenceNo = json['reference_no'];
    specialslimit = json['specialcountlimit'];
  }
}

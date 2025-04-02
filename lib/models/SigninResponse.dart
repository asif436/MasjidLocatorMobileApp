// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SecureHomeData {
  Entity? entity;
  String? advertisementImage;
  SecureHomeData(entity, advertisementImage) {
    this.entity = entity;
    this.advertisementImage = advertisementImage;
  }

/*
  get getEntity => entity;
  set setEntity(entity) => this.entity = entity;
  get getAdvertisementImage => advertisementImage;
  set setAdvertisementImage(advertisementImage) =>
      this.advertisementImage = advertisementImage;
      */
}

class Advertisement {
  int? advertisementId;
  String? adminArea;
  String? subAdminArea;
  String? country;
  String? startDate;
  String? endDate;
  String? imageURL;
  int? isLink;
  int? isActive;
  int? counter;
  String? companyName;
  String? contactPerson;
  String? contactDesignation;

  Advertisement(
      this.advertisementId,
      this.adminArea,
      this.subAdminArea,
      this.country,
      this.startDate,
      this.endDate,
      this.imageURL,
      this.isLink,
      this.isActive,
      this.counter,
      this.companyName,
      this.contactPerson,
      this.contactDesignation);

  get getAdvertisementId => advertisementId;

  set setAdvertisementId(int advertisementId) =>
      this.advertisementId = advertisementId;

  get getAdminArea => adminArea;

  set setAdminArea(adminArea) => this.adminArea = adminArea;

  get getSubAdminArea => subAdminArea;

  set setSubAdminArea(subAdminArea) => this.subAdminArea = subAdminArea;

  get getCountry => country;

  set setCountry(country) => this.country = country;

  get getStartDate => startDate;

  set setStartDate(startDate) => this.startDate = startDate;

  get getEndDate => endDate;

  set setEndDate(endDate) => this.endDate = endDate;

  get getImageURL => imageURL;

  set setImageURL(imageURL) => this.imageURL = imageURL;

  get getIsLink => isLink;

  set setIsLink(isLink) => this.isLink = isLink;

  get getIsActive => isActive;

  set setIsActive(isActive) => this.isActive = isActive;

  get getCounter => counter;

  set setCounter(counter) => this.counter = counter;

  get getCompanyName => companyName;

  set setCompanyName(companyName) => this.companyName = companyName;

  get getContactPerson => contactPerson;

  set setContactPerson(contactPerson) => this.contactPerson = contactPerson;

  get getContactDesignation => contactDesignation;

  set setContactDesignation(contactDesignation) =>
      this.contactDesignation = contactDesignation;

  Advertisement copyWith({
    int? advertisementId,
    String? adminArea,
    String? subAdminArea,
    String? country,
    String? startDate,
    String? endDate,
    String? imageURL,
    int? isLink,
    int? isActive,
    int? counter,
    String? companyName,
    String? contactPerson,
    String? contactDesignation,
  }) {
    return Advertisement(
      advertisementId ?? this.advertisementId,
      adminArea ?? this.adminArea,
      subAdminArea ?? this.subAdminArea,
      country ?? this.country,
      startDate ?? this.startDate,
      endDate ?? this.endDate,
      imageURL ?? this.imageURL,
      isLink ?? this.isLink,
      isActive ?? this.isActive,
      counter ?? this.counter,
      companyName ?? this.companyName,
      contactPerson ?? this.contactPerson,
      contactDesignation ?? this.contactDesignation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'advertisementId': advertisementId,
      'adminArea': adminArea,
      'subAdminArea': subAdminArea,
      'country': country,
      'startDate': startDate,
      'endDate': endDate,
      'imageURL': imageURL,
      'isLink': isLink,
      'isActive': isActive,
      'counter': counter,
      'companyName': companyName,
      'contactPerson': contactPerson,
      'contactDesignation': contactDesignation,
    };
  }

  factory Advertisement.fromMap(Map<String, dynamic> map) {
    return Advertisement(
      map['advertisementId'] != null ? map['advertisementId'] as int : null,
      map['adminArea'] != null ? map['adminArea'] as String : null,
      map['subAdminArea'] != null ? map['subAdminArea'] as String : null,
      map['country'] != null ? map['country'] as String : null,
      map['startDate'] != null ? map['startDate'] as String : null,
      map['endDate'] != null ? map['endDate'] as String : null,
      map['imageURL'] != null ? map['imageURL'] as String : null,
      map['isLink'] != null ? map['isLink'] as int : null,
      map['isActive'] != null ? map['isActive'] as int : null,
      map['counter'] != null ? map['counter'] as int : null,
      map['companyName'] != null ? map['companyName'] as String : null,
      map['contactPerson'] != null ? map['contactPerson'] as String : null,
      map['contactDesignation'] != null
          ? map['contactDesignation'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Advertisement.fromJson(String source) =>
      Advertisement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Advertisement(advertisementId: $advertisementId, adminArea: $adminArea, subAdminArea: $subAdminArea, country: $country, startDate: $startDate, endDate: $endDate, imageURL: $imageURL, isLink: $isLink, isActive: $isActive, counter: $counter, companyName: $companyName, contactPerson: $contactPerson, contactDesignation: $contactDesignation)';
  }

  @override
  bool operator ==(covariant Advertisement other) {
    if (identical(this, other)) return true;

    return other.advertisementId == advertisementId &&
        other.adminArea == adminArea &&
        other.subAdminArea == subAdminArea &&
        other.country == country &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.imageURL == imageURL &&
        other.isLink == isLink &&
        other.isActive == isActive &&
        other.counter == counter &&
        other.companyName == companyName &&
        other.contactPerson == contactPerson &&
        other.contactDesignation == contactDesignation;
  }

  @override
  int get hashCode {
    return advertisementId.hashCode ^
        adminArea.hashCode ^
        subAdminArea.hashCode ^
        country.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        imageURL.hashCode ^
        isLink.hashCode ^
        isActive.hashCode ^
        counter.hashCode ^
        companyName.hashCode ^
        contactPerson.hashCode ^
        contactDesignation.hashCode;
  }
}

class Sects {
  int? sectId;
  String? sectName;
  String? sectDesc;
  Sects({
    this.sectId,
    this.sectName,
    this.sectDesc,
  });

  Sects copyWith({
    int? sectId,
    String? sectName,
    String? sectDesc,
  }) {
    return Sects(
      sectId: sectId ?? this.sectId,
      sectName: sectName ?? this.sectName,
      sectDesc: sectDesc ?? this.sectDesc,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sect_id': sectId,
      'sect_name': sectName,
      'sect_desc': sectDesc,
    };
  }

  factory Sects.fromMap(Map<String, dynamic> map) {
    return Sects(
      sectId: map['sect_id'] != null ? map['sect_id'] as int : null,
      sectName: map['sect_name'] != null ? map['sect_name'] as String : null,
      sectDesc: map['sect_desc'] != null ? map['sect_desc'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sects.fromJson(String source) =>
      Sects.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Sects(sectId: $sectId, sectName: $sectName, sectDesc: $sectDesc)';

  @override
  bool operator ==(covariant Sects other) {
    if (identical(this, other)) return true;

    return other.sectId == sectId &&
        other.sectName == sectName &&
        other.sectDesc == sectDesc;
  }

  @override
  int get hashCode => sectId.hashCode ^ sectName.hashCode ^ sectDesc.hashCode;
}

class Messages {
  int? msgId;
  String? msgSubject;
  String? msgBody;
  String? msgDate;
  int? entityId;

  Messages({
    this.msgId,
    this.msgSubject,
    this.msgBody,
    this.msgDate,
    this.entityId,
  });

  constructor(msgId, msgSubject, msgBody, msgDate, entityId) {
    msgId = msgId;
    msgSubject = msgSubject;
    msgBody = msgBody;
    msgDate = msgDate;
    entityId = entityId;
  }

/*
  get getMsgId => msgId;
  set setMsgId(msgId) => this.msgId = msgId;
  get getMsgSubject => msgSubject;
  set setMsgSubject(msgSubject) => this.msgSubject = msgSubject;
  get getMsgBody => msgBody;
  set setMsgBody(msgBody) => this.msgBody = msgBody;
  get getMsgDate => msgDate;
  set setMsgDate(msgDate) => this.msgDate = msgDate;
  get getEntityId => entityId;
  set setEntityId(entityId) => this.entityId = entityId;
*/
  Messages copyWith({
    int? msgId,
    String? msgSubject,
    String? msgBody,
    String? msgDate,
    int? entityId,
  }) {
    return Messages(
      msgId: msgId ?? this.msgId,
      msgSubject: msgSubject ?? this.msgSubject,
      msgBody: msgBody ?? this.msgBody,
      msgDate: msgDate ?? this.msgDate,
      entityId: entityId ?? this.entityId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message_id': msgId,
      'message_subject': msgSubject,
      'message_body': msgBody,
      'message_date': msgDate,
      'entities_entity_id': entityId,
    };
  }

  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      msgId: map['message_id'] != null ? map['message_id'] as int : null,
      msgSubject: map['message_subject'] != null
          ? map['message_subject'] as String
          : null,
      msgBody:
          map['message_body'] != null ? map['message_body'] as String : null,
      msgDate:
          map['message_date'] != null ? map['message_date'] as String : null,
      entityId: map['entities_entity_id'] != null
          ? map['entities_entity_id'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Messages.fromJson(String source) =>
      Messages.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Messages(message_id: $msgId, message_subject: $msgSubject, message_body: $msgBody, message_date: $msgDate, entities_entity_id: $entityId)';
  }

  @override
  bool operator ==(covariant Messages other) {
    if (identical(this, other)) return true;

    return other.msgId == msgId &&
        other.msgSubject == msgSubject &&
        other.msgBody == msgBody &&
        other.msgDate == msgDate &&
        other.entityId == entityId;
  }

  @override
  int get hashCode {
    return msgId.hashCode ^
        msgSubject.hashCode ^
        msgBody.hashCode ^
        msgDate.hashCode ^
        entityId.hashCode;
  }
}

class Donation {
  String bankName;
  String accountHolderName;
  String accountNumber;

  get getBankName => bankName;
  set setBankName(bankName) => this.bankName = bankName;
  get getAccountHolderName => accountHolderName;
  set setAccountHolderName(accountHolderName) =>
      this.accountHolderName = accountHolderName;
  get getAccountNumber => accountNumber;
  set setAccountNumber(accountNumber) => this.accountNumber = accountNumber;

  Donation({
    required this.bankName,
    required this.accountHolderName,
    required this.accountNumber,
  });

  Donation copyWith({
    String? bankName,
    String? accountHolderName,
    String? accountNumber,
  }) {
    return Donation(
      bankName: bankName ?? this.bankName,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bank_name': bankName,
      'acc_holder_name': accountHolderName,
      'bank_acc_number': accountNumber,
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      bankName: map['bank_name'] ?? '',
      accountHolderName:
          map['acc_holder_name'] ?? '',
      accountNumber:
          map['bank_acc_number'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Donation.fromJson(String source) =>
      Donation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Donation(bankName: $bankName, accountHolderName: $accountHolderName, accountNumber: $accountNumber)';

  @override
  bool operator ==(covariant Donation other) {
    if (identical(this, other)) return true;

    return other.bankName == bankName &&
        other.accountHolderName == accountHolderName &&
        other.accountNumber == accountNumber;
  }

  @override
  int get hashCode =>
      bankName.hashCode ^ accountHolderName.hashCode ^ accountNumber.hashCode;
}

class Profiles {
  int? profilesId;
  String? profilerName;
  String? profilerEmail;
  String? profilerPhone;
  String? profilerAddress;
  String? websiteURL;
  String? profilerImageURL;
  Profiles({
    this.profilesId,
    this.profilerName,
    this.profilerEmail,
    this.profilerPhone,
    this.profilerAddress,
    this.websiteURL,
    this.profilerImageURL,
  });

  Profiles copyWith({
    int? profilesId,
    String? profilerName,
    String? profilerEmail,
    String? profilerPhone,
    String? profilerAddress,
    String? websiteURL,
    String? profilerImageURL,
  }) {
    return Profiles(
      profilesId: profilesId ?? this.profilesId,
      profilerName: profilerName ?? this.profilerName,
      profilerEmail: profilerEmail ?? this.profilerEmail,
      profilerPhone: profilerPhone ?? this.profilerPhone,
      profilerAddress: profilerAddress ?? this.profilerAddress,
      websiteURL: websiteURL ?? this.websiteURL,
      profilerImageURL: profilerImageURL ?? this.profilerImageURL,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profilesId': profilesId,
      'profilerName': profilerName,
      'profilerEmail': profilerEmail,
      'profilerPhone': profilerPhone,
      'profilerAddress': profilerAddress,
      'websiteURL': websiteURL,
      'profilerImageURL': profilerImageURL,
    };
  }

  factory Profiles.fromMap(Map<String, dynamic> map) {
    return Profiles(
      profilesId: map['profile_id'],
      profilerName:
          map['profiler_name'] != null ? map['profiler_name'] as String : null,
      profilerEmail: map['profiler_email'] != null
          ? map['profiler_email'] as String
          : null,
      profilerPhone: map['profiler_phone'] != null
          ? map['profiler_phone'] as String
          : null,
      profilerAddress: map['profiler_address'] != null
          ? map['profiler_address'] as String
          : null,
      websiteURL:
          map['website_url'] != null ? map['website_url'] as String : null,
      profilerImageURL: map['profiler_image_url'] != null
          ? map['profiler_image_url'] as String?
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Profiles.fromJson(String source) =>
      Profiles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Profiles(profilesId: $profilesId, profilerName: $profilerName, profilerEmail: $profilerEmail, profilerPhone: $profilerPhone, profilerAddress: $profilerAddress, websiteURL: $websiteURL, profileImageURL: $profilerImageURL)';
  }

  @override
  bool operator ==(covariant Profiles other) {
    if (identical(this, other)) return true;

    return other.profilesId == profilesId &&
        other.profilerName == profilerName &&
        other.profilerEmail == profilerEmail &&
        other.profilerPhone == profilerPhone &&
        other.profilerAddress == profilerAddress &&
        other.websiteURL == websiteURL &&
        other.profilerImageURL == profilerImageURL;
  }

  @override
  int get hashCode {
    return profilesId.hashCode ^
        profilerName.hashCode ^
        profilerEmail.hashCode ^
        profilerPhone.hashCode ^
        profilerAddress.hashCode ^
        websiteURL.hashCode ^
        profilerImageURL.hashCode;
  }
}

class Users {
  int? userId;
  String? userName;
  int? profileId;
  Profiles? profile;
  int? preferencesId;

  Users({
    this.userId,
    this.userName,
    this.profileId,
    this.profile,
    this.preferencesId,
  });

  get getUserId => userId;
  set setUserId(userId) => this.userId = userId;
  get getUserName => userName;
  set setUserName(userName) => this.userName = userName;
  get getProfileId => profileId;
  set setProfileId(profileId) => this.profileId = profileId;
  get getProfile => profile;
  set setProfile(profile) => this.profile = profile;
  get getPreferencesId => preferencesId;
  set setPreferencesId(preferencesId) => this.preferencesId = preferencesId;

  Users copyWith({
    int? userId,
    String? userName,
    int? profileId,
    Profiles? profile,
    int? preferencesId,
  }) {
    return Users(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      profileId: profileId ?? this.profileId,
      profile: profile ?? this.profile,
      preferencesId: preferencesId ?? this.preferencesId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'username': userName,
      'profiles_profile_id': profileId,
      'profile': profile?.toMap(),
      'user_preferences_preference_id': preferencesId,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      userId: map['user_id'] != null ? map['user_id'] as int : null,
      userName: map['username'] != null ? map['username'] as String : null,
      profileId: map['profiles_profile_Id'] != null
          ? map['profiles_profile_Id'] as int
          : null,
      profile: map['profiles_model'] != null
          ? Profiles.fromMap(map['profiles_model'])
          : null,
      preferencesId: map['user_preferences_preference_id'] != null
          ? map['user_preferences_preference_id'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) =>
      Users.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Users(user_id: $userId, username: $userName, profiles_profile_id: $profileId, profile: $profile, user_preferences_preference_id: $preferencesId)';
  }

  @override
  bool operator ==(covariant Users other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.userName == userName &&
        other.profileId == profileId &&
        other.profile == profile &&
        other.preferencesId == preferencesId;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userName.hashCode ^
        profileId.hashCode ^
        profile.hashCode ^
        preferencesId.hashCode;
  }
}

class EntitySchedule {
  int? entity_schedule_id;
  int? Monday;
  int? Tuesday;
  int? Wednesday;
  int? Thursday;
  int? Friday;
  int? Saturday;
  int? Sunday;
  int? Seven_Days;
  String? Fajr;
  String? Duhur;
  String? Asr;
  String? Maghrib;
  String? Isha;
  String? Jumma;
  int? arrangement_for_Jamat;
  int? arrangment_for_ittikaf;
  EntitySchedule({
    this.entity_schedule_id,
    this.Monday,
    this.Tuesday,
    this.Wednesday,
    this.Thursday,
    this.Friday,
    this.Saturday,
    this.Sunday,
    this.Seven_Days,
    this.Fajr,
    this.Duhur,
    this.Asr,
    this.Maghrib,
    this.Isha,
    this.Jumma,
    this.arrangement_for_Jamat,
    this.arrangment_for_ittikaf,
  });

  constructor(
      entityScheduleId,
      Monday,
      Tuesday,
      Wednesday,
      Thursday,
      Friday,
      Saturday,
      Sunday,
      sevenDays,
      Fajr,
      Duhur,
      Asr,
      Maghrib,
      Isha,
      Jumma,
      arrangementForJamat,
      arrangmentForIttikaf) {
    entity_schedule_id = entityScheduleId;
    this.Monday = Monday;
    this.Tuesday = Tuesday;
    this.Wednesday = Wednesday;
    this.Thursday = Thursday;
    this.Friday = Friday;
    this.Saturday = Saturday;
    this.Sunday = Sunday;
    Seven_Days = sevenDays;
    this.Fajr = Fajr;
    this.Duhur = Duhur;
    this.Asr = Asr;
    this.Maghrib = Maghrib;
    this.Isha = Isha;
    this.Jumma = Jumma;
    arrangement_for_Jamat = arrangementForJamat;
    arrangment_for_ittikaf = arrangementForJamat;
  }
  // Getter Methods

  getEntity_schedule_id() {
    return entity_schedule_id;
  }

  getMonday() {
    return Monday;
  }

  getTuesday() {
    return Tuesday;
  }

  getWednesday() {
    return Wednesday;
  }

  getThursday() {
    return Thursday;
  }

  getFriday() {
    return Friday;
  }

  getSaturday() {
    return Saturday;
  }

  getSunday() {
    return Sunday;
  }

  getSeven_Days() {
    return Seven_Days;
  }

  getFajr() {
    return Fajr;
  }

  getDuhur() {
    return Duhur;
  }

  getAsr() {
    return Asr;
  }

  getMaghrib() {
    return Maghrib;
  }

  getIsha() {
    return Isha;
  }

  getJumma() {
    return Jumma;
  }

  getArrangement_for_Jamat() {
    return arrangement_for_Jamat;
  }

  getArrangment_for_ittikaf() {
    return arrangment_for_ittikaf;
  }

  // Setter Methods

  void setEntity_schedule_id(int entityScheduleId) {
    entity_schedule_id = entityScheduleId;
  }

  void setMonday(int Monday) {
    this.Monday = Monday;
  }

  void setTuesday(int Tuesday) {
    this.Tuesday = Tuesday;
  }

  void setWednesday(int Wednesday) {
    this.Wednesday = Wednesday;
  }

  void setThursday(int Thursday) {
    this.Thursday = Thursday;
  }

  void setFriday(int Friday) {
    this.Friday = Friday;
  }

  void setSaturday(int Saturday) {
    this.Saturday = Saturday;
  }

  void setSunday(int Sunday) {
    this.Sunday = Sunday;
  }

  void setSeven_Days(int sevenDays) {
    Seven_Days = sevenDays;
  }

  void setFajr(String Fajr) {
    this.Fajr = Fajr;
  }

  void setDuhur(String Duhur) {
    this.Duhur = Duhur;
  }

  void setAsr(String Asr) {
    this.Asr = Asr;
  }

  void setMaghrib(String Maghrib) {
    this.Maghrib = Maghrib;
  }

  void setIsha(String Isha) {
    this.Isha = Isha;
  }

  void setJumma(String Jumma) {
    this.Jumma = Jumma;
  }

  void setArrangement_for_Jamat(int arrangementForJamat) {
    arrangement_for_Jamat = arrangementForJamat;
  }

  void setArrangment_for_ittikaf(int arrangmentForIttikaf) {
    arrangment_for_ittikaf = arrangmentForIttikaf;
  }

  EntitySchedule copyWith({
    int? entity_schedule_id,
    int? Monday,
    int? Tuesday,
    int? Wednesday,
    int? Thursday,
    int? Friday,
    int? Saturday,
    int? Sunday,
    int? Seven_Days,
    String? Fajr,
    String? Duhur,
    String? Asr,
    String? Maghrib,
    String? Isha,
    String? Jumma,
    int? arrangement_for_Jamat,
    int? arrangment_for_ittikaf,
  }) {
    return EntitySchedule(
      entity_schedule_id: entity_schedule_id ?? this.entity_schedule_id,
      Monday: Monday ?? this.Monday,
      Tuesday: Tuesday ?? this.Tuesday,
      Wednesday: Wednesday ?? this.Wednesday,
      Thursday: Thursday ?? this.Thursday,
      Friday: Friday ?? this.Friday,
      Saturday: Saturday ?? this.Saturday,
      Sunday: Sunday ?? this.Sunday,
      Seven_Days: Seven_Days ?? this.Seven_Days,
      Fajr: Fajr ?? this.Fajr,
      Duhur: Duhur ?? this.Duhur,
      Asr: Asr ?? this.Asr,
      Maghrib: Maghrib ?? this.Maghrib,
      Isha: Isha ?? this.Isha,
      Jumma: Jumma ?? this.Jumma,
      arrangement_for_Jamat:
          arrangement_for_Jamat ?? this.arrangement_for_Jamat,
      arrangment_for_ittikaf:
          arrangment_for_ittikaf ?? this.arrangment_for_ittikaf,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'entity_schedule_id': entity_schedule_id,
      'Monday': Monday,
      'Tuesday': Tuesday,
      'Wednesday': Wednesday,
      'Thursday': Thursday,
      'Friday': Friday,
      'Saturday': Saturday,
      'Sunday': Sunday,
      'Seven_Days': Seven_Days,
      'Fajr': Fajr,
      'Duhur': Duhur,
      'Asr': Asr,
      'Maghrib': Maghrib,
      'Isha': Isha,
      'Jumma': Jumma,
      'arrangement_for_Jamat': arrangement_for_Jamat,
      'arrangment_for_ittikaf': arrangment_for_ittikaf,
    };
  }

  factory EntitySchedule.fromMap(Map<String, dynamic> map) {
    return EntitySchedule(
      entity_schedule_id: map['entity_schedule_id'] != null
          ? map['entity_schedule_id'] as int
          : null,
      Monday: map['Monday'] != null ? map['Monday'] as int : null,
      Tuesday: map['Tuesday'] != null ? map['Tuesday'] as int : null,
      Wednesday: map['Wednesday'] != null ? map['Wednesday'] as int : null,
      Thursday: map['Thursday'] != null ? map['Thursday'] as int : null,
      Friday: map['Friday'] != null ? map['Friday'] as int : null,
      Saturday: map['Saturday'] != null ? map['Saturday'] as int : null,
      Sunday: map['Sunday'] != null ? map['Sunday'] as int : null,
      Seven_Days: map['Seven_Days'] != null ? map['Seven_Days'] as int : null,
      Fajr: map['Fajr'] != null ? map['Fajr'] as String : null,
      Duhur: map['Duhur'] != null ? map['Duhur'] as String : null,
      Asr: map['Asr'] != null ? map['Asr'] as String : null,
      Maghrib: map['Maghrib'] != null ? map['Maghrib'] as String : null,
      Isha: map['Isha'] != null ? map['Isha'] as String : null,
      Jumma: map['Jumma'] != null ? map['Jumma'] as String : null,
      arrangement_for_Jamat: map['arrangement_for_Jamat'] != null
          ? map['arrangement_for_Jamat'] as int
          : null,
      arrangment_for_ittikaf: map['arrangment_for_ittikaf'] != null
          ? map['arrangment_for_ittikaf'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EntitySchedule.fromJson(String source) =>
      EntitySchedule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Entity_schedule_model(entity_schedule_id: $entity_schedule_id, Monday: $Monday, Tuesday: $Tuesday, Wednesday: $Wednesday, Thursday: $Thursday, Friday: $Friday, Saturday: $Saturday, Sunday: $Sunday, Seven_Days: $Seven_Days, Fajr: $Fajr, Duhur: $Duhur, Asr: $Asr, Maghrib: $Maghrib, Isha: $Isha, Jumma: $Jumma, arrangement_for_Jamat: $arrangement_for_Jamat, arrangment_for_ittikaf: $arrangment_for_ittikaf)';
  }

  @override
  bool operator ==(covariant EntitySchedule other) {
    if (identical(this, other)) return true;

    return other.entity_schedule_id == entity_schedule_id &&
        other.Monday == Monday &&
        other.Tuesday == Tuesday &&
        other.Wednesday == Wednesday &&
        other.Thursday == Thursday &&
        other.Friday == Friday &&
        other.Saturday == Saturday &&
        other.Sunday == Sunday &&
        other.Seven_Days == Seven_Days &&
        other.Fajr == Fajr &&
        other.Duhur == Duhur &&
        other.Asr == Asr &&
        other.Maghrib == Maghrib &&
        other.Isha == Isha &&
        other.Jumma == Jumma &&
        other.arrangement_for_Jamat == arrangement_for_Jamat &&
        other.arrangment_for_ittikaf == arrangment_for_ittikaf;
  }

  @override
  int get hashCode {
    return entity_schedule_id.hashCode ^
        Monday.hashCode ^
        Tuesday.hashCode ^
        Wednesday.hashCode ^
        Thursday.hashCode ^
        Friday.hashCode ^
        Saturday.hashCode ^
        Sunday.hashCode ^
        Seven_Days.hashCode ^
        Fajr.hashCode ^
        Duhur.hashCode ^
        Asr.hashCode ^
        Maghrib.hashCode ^
        Isha.hashCode ^
        Jumma.hashCode ^
        arrangement_for_Jamat.hashCode ^
        arrangment_for_ittikaf.hashCode;
  }
}

class Entity {
  int? entity_Id;
  String? entity_name;
  double? lat;
  double? log;
  String? country;
  String? region;
  String? adminArea;
  String? subAdminArea;
  int? isVerified;
  String? entityImageURL;
  String? created_date;
  int? entity_schedule_entity_schedule_id;
  int? donation_donation_id;
  int? sects_sect_id;
  Users? user;
  EntitySchedule? entitySchedule;
  Donation? donation;
  Sects? sect;

  Entity(
      {this.entity_Id,
      this.entity_name,
      this.lat,
      this.log,
      this.country,
      this.region,
      this.adminArea,
      this.subAdminArea,
      this.isVerified,
      this.entityImageURL,
      this.created_date,
      this.entity_schedule_entity_schedule_id,
      this.user,
      this.donation_donation_id,
      this.entitySchedule,
      this.donation,
      this.sects_sect_id,
      this.sect});

  // Getter Methods

  getEntity_Id() {
    return entity_Id;
  }

  getEntity_name() {
    return entity_name;
  }

  getLat() {
    return lat;
  }

  getLog() {
    return log;
  }

  getCountry() {
    return country;
  }

  getRegion() {
    return region;
  }

  getAdminArea() {
    return adminArea;
  }

  getSubAdminArea() {
    return subAdminArea;
  }

  getIsVerified() {
    return isVerified;
  }

  getEntityImageURL() {
    return entityImageURL;
  }

  getCreated_date() {
    return created_date;
  }

  getEntity_schedule_entity_schedule_id() {
    return entity_schedule_entity_schedule_id;
  }

  getUser() {
    return user;
  }

  getDonation_donation_id() {
    return donation_donation_id;
  }

  getEntitySchedule() {
    return entitySchedule;
  }

  getDonation() {
    return donation;
  }

  getSects_sect_id() {
    return sects_sect_id;
  }

  getSect() {
    return sect;
  }

  // Setter Methods

  void setEntity_Id(int entityId) {
    entity_Id = entityId;
  }

  void setEntity_name(String entityName) {
    entity_name = entityName;
  }

  void setLat(double lat) {
    this.lat = lat;
  }

  void setLog(double log) {
    this.log = log;
  }

  void setCountry(String country) {
    this.country = country;
  }

  void setRegion(String region) {
    this.region = region;
  }

  void setAdminArea(String adminArea) {
    this.adminArea = adminArea;
  }

  void setSubAdminArea(String subAdminArea) {
    this.subAdminArea = subAdminArea;
  }

  void setIsVerified(int isVerified) {
    this.isVerified = isVerified;
  }

  void setEntityImageURL(String entityImageURL) {
    this.entityImageURL = entityImageURL;
  }

  void setCreated_date(String createdDate) {
    created_date = createdDate;
  }

  void setEntity_schedule_entity_schedule_id(
      int entityScheduleEntityScheduleId) {
    entity_schedule_entity_schedule_id =
        entityScheduleEntityScheduleId;
  }

  void setUser(Users user) {
    this.user = user;
  }

  void setDonation_donation_id(int donationDonationId) {
    donation_donation_id = donationDonationId;
  }

  void setEntitySchedule(EntitySchedule entitySchedule) {
    this.entitySchedule = entitySchedule;
  }

  void setSects_sect_id(int sectsSectId) {
    sects_sect_id = sectsSectId;
  }

  void setDonation(Donation donation) {
    this.donation = donation;
  }

  void setSect(Sects sect) {
    this.sect = sect;
  }

  Entity copyWith(
      {int? entity_Id,
      String? entity_name,
      double? lat,
      double? log,
      String? country,
      String? region,
      String? adminArea,
      String? subAdminArea,
      int? isVerified,
      List<dynamic>? entity_pic,
      List<dynamic>? admin_pic,
      String? created_date,
      int? entity_schedule_entity_schedule_id,
      int? donation_donation_id,
      int? sects_sect_id,
      Users? user,
      EntitySchedule? Entity_schedule_modelObject,
      Sects? sect}) {
    return Entity(
        entity_Id: entity_Id ?? this.entity_Id,
        entity_name: entity_name ?? this.entity_name,
        lat: lat ?? this.lat,
        log: log ?? this.log,
        country: country ?? this.country,
        region: region ?? this.region,
        adminArea: adminArea ?? this.adminArea,
        subAdminArea: subAdminArea ?? this.subAdminArea,
        isVerified: isVerified ?? this.isVerified,
        entityImageURL: entityImageURL ?? entityImageURL,
        created_date: created_date ?? this.created_date,
        entity_schedule_entity_schedule_id:
            entity_schedule_entity_schedule_id ??
                this.entity_schedule_entity_schedule_id,
        donation_donation_id: donation_donation_id ?? this.donation_donation_id,
        entitySchedule: Entity_schedule_modelObject,
        user: user ?? this.user,
        sect: sect ?? this.sect);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'entity_Id': entity_Id,
      'entity_name': entity_name,
      'lat': lat,
      'log': log,
      'country': country,
      'region': region,
      'adminArea': adminArea,
      'subAdminArea': subAdminArea,
      'isVerified': isVerified,
      'entityImageURL': entityImageURL,
      'created_date': created_date,
      'entity_schedule_entity_schedule_id': entity_schedule_entity_schedule_id,
      'donation_donation_id': donation_donation_id,
      'sects_sect_id': sects_sect_id,
      'sect': sect
    };
  }

  factory Entity.fromMap(Map<String, dynamic> map) {
    return Entity(
        entity_Id: map['entity_Id'] != null ? map['entity_Id'] as int : null,
        entity_name:
            map['entity_name'] != null ? map['entity_name'] as String : null,
        lat: map['lat'] != null ? map['lat'] as double : null,
        log: map['log'] != null ? map['log'] as double : null,
        country: map['country'] != null ? map['country'] as String : null,
        region: map['region'] != null ? map['region'] as String : null,
        adminArea:
            map['admin_area'] != null ? map['admin_area'] as String : null,
        subAdminArea: map['subadmin_area'] != null
            ? map['subadmin_area'] as String
            : null,
        isVerified: map['isVerified'] != null ? map['isVerified'] as int : null,
        entityImageURL: map['entity_image_url'] != null
            ? map['entity_image_url'] as String?
            : null,
        created_date:
            map['created_date'] != null ? map['created_date'] as String : null,
        entity_schedule_entity_schedule_id:
            map['entity_schedule_entity_schedule_id'] != null
                ? map['entity_schedule_entity_schedule_id'] as int
                : null,
        donation_donation_id: map['donation_donation_id'] != null
            ? map['donation_donation_id'] as int
            : null,
        entitySchedule: map['entity_schedule_model'] != null
            ? EntitySchedule.fromMap(map['entity_schedule_model'])
            : null,
        donation: map['donation_model'] != null
            ? Donation.fromMap(map['donation_model'])
            : null,
        sects_sect_id:
            map['sects_sect_id'] != null ? map['sects_sect_id'] as int : null,
        user: map['users_model'] != null
            ? Users.fromMap(map['users_model'])
            : null,
        sect: map['sects_model'] != null
            ? Sects.fromMap(map['sects_model'])
            : null);
  }

  String toJson() => json.encode(toMap());

  factory Entity.fromJson(String source) =>
      Entity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Entity(entity_Id: $entity_Id, entity_name: $entity_name, lat: $lat, log: $log, country: $country, region: $region, isVerified: $isVerified, created_date: $created_date, entity_schedule_entity_schedule_id: $entity_schedule_entity_schedule_id, donation_donation_id: $donation_donation_id, sects_sect_id: $sects_sect_id)';
  }

  @override
  bool operator ==(covariant Entity other) {
    if (identical(this, other)) return true;

    return other.entity_Id == entity_Id &&
        other.entity_name == entity_name &&
        other.lat == lat &&
        other.log == log &&
        other.country == country &&
        other.region == region &&
        other.isVerified == isVerified &&
        other.created_date == created_date &&
        other.entity_schedule_entity_schedule_id ==
            entity_schedule_entity_schedule_id &&
        other.donation_donation_id == donation_donation_id;
  }

  @override
  int get hashCode {
    return entity_Id.hashCode ^
        entity_name.hashCode ^
        lat.hashCode ^
        log.hashCode ^
        country.hashCode ^
        region.hashCode ^
        isVerified.hashCode ^
        created_date.hashCode ^
        entity_schedule_entity_schedule_id.hashCode ^
        donation_donation_id.hashCode;
  }
}

class Result {
  String? name;
  String? username;
  int? role;
  String? email;
  Entity? EntityObject;
  String? token;
  int? expiresIn;
  Result({
    this.name,
    this.username,
    this.role,
    this.email,
    this.EntityObject,
    this.token,
    this.expiresIn,
  });

  constructor(name, username, role, email, entityObject, token, expiresIn) {
    this.name = name;
    this.username = username;
    this.role = role;
    this.email = email;
    EntityObject = EntityObject;
    this.token = token;
    this.expiresIn = expiresIn;
  }
  // Getter Methods

  getName() {
    return name;
  }

  getUsername() {
    return username;
  }

  getRole() {
    return role;
  }

  getEmail() {
    return email;
  }

  getEntity() {
    return EntityObject;
  }

  getToken() {
    return token;
  }

  getExpiresIn() {
    return expiresIn;
  }

  // Setter Methods

  void setName(String name) {
    this.name = name;
  }

  void setUsername(String username) {
    this.username = username;
  }

  void setRole(int role) {
    this.role = role;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setEntity(Entity entityObject) {
    EntityObject = entityObject;
  }

  void setToken(String token) {
    this.token = token;
  }

  void setExpiresIn(int expiresIn) {
    this.expiresIn = expiresIn;
  }

  Result copyWith({
    String? name,
    String? username,
    int? role,
    String? email,
    Entity? EntityObject,
    String? token,
    int? expiresIn,
  }) {
    return Result(
      name: name ?? this.name,
      username: username ?? this.username,
      role: role ?? this.role,
      email: email ?? this.email,
      EntityObject: EntityObject ?? this.EntityObject,
      token: token ?? this.token,
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'username': username,
      'role': role,
      'email': email,
      'EntityObject': EntityObject?.toMap(),
      'token': token,
      'expiresIn': expiresIn,
    };
  }

  factory Result.fromMap(Map<String, dynamic> map) {
    return Result(
      name: map['name'] != null ? map['name'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      role: map['role'] != null ? map['role'] as int : null,
      email: map['email'] != null ? map['email'] as String : null,
      EntityObject: map['EntityObject'] != null
          ? Entity.fromMap(map['EntityObject'] as Map<String, dynamic>)
          : null,
      token: map['token'] != null ? map['token'] as String : null,
      expiresIn: map['expiresIn'] != null ? map['expiresIn'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Result.fromJson(String source) =>
      Result.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Result(name: $name, username: $username, role: $role, email: $email, EntityObject: $EntityObject, token: $token, expiresIn: $expiresIn)';
  }

  @override
  bool operator ==(covariant Result other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.username == username &&
        other.role == role &&
        other.email == email &&
        other.EntityObject == EntityObject &&
        other.token == token &&
        other.expiresIn == expiresIn;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        username.hashCode ^
        role.hashCode ^
        email.hashCode ^
        EntityObject.hashCode ^
        token.hashCode ^
        expiresIn.hashCode;
  }
}

class SigninResponse {
  Result? resultObject;
  String? message;
  SigninResponse({
    this.resultObject,
    this.message,
  });

  constructor(Result resultObject, String message) {
    this.resultObject = resultObject;
    this.message = message;
  }
  // Getter Methods

  getResult() {
    return resultObject;
  }

  getMessage() {
    return message;
  }

  // Setter Methods

  void setResult(Result resultObject) {
    this.resultObject = resultObject;
  }

  void setMessage(String message) {
    this.message = message;
  }

  SigninResponse copyWith({
    Result? resultObject,
    String? message,
  }) {
    return SigninResponse(
      resultObject: resultObject ?? this.resultObject,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'resultObject': resultObject?.toMap(),
      'message': message,
    };
  }

  factory SigninResponse.fromMap(Map<String, dynamic> map) {
    return SigninResponse(
      resultObject: map['resultObject'] != null
          ? Result.fromMap(map['resultObject'] as Map<String, dynamic>)
          : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SigninResponse.fromJson(String source) =>
      SigninResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SigninResponse(resultObject: $resultObject, message: $message)';

  @override
  bool operator ==(covariant SigninResponse other) {
    if (identical(this, other)) return true;

    return other.resultObject == resultObject && other.message == message;
  }

  @override
  int get hashCode => resultObject.hashCode ^ message.hashCode;
}

class RegistrationRespose {
  String title = '';
  String content = '';
}

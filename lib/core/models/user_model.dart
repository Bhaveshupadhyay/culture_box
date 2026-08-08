import 'package:equatable/equatable.dart';

class SubscriptionDetails extends Equatable {
  final String subId;
  final String plan;
  final String expiry;
  final String status;
  final String amount;

  const SubscriptionDetails({
    required this.subId,
    required this.plan,
    required this.expiry,
    required this.status,
    required this.amount,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    return SubscriptionDetails(
      subId: json['sub_id']?.toString() ?? '',
      plan: json['plan']?.toString() ?? '',
      expiry: json['expiry']?.toString() ?? '',
      status: json['status']?.toString() ?? 'expired',
      amount: json['amount']?.toString() ?? '0.0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub_id': subId,
      'plan': plan,
      'expiry': expiry,
      'status': status,
      'amount': amount,
    };
  }

  @override
  List<Object?> get props => [subId, plan, expiry, status, amount];
}

class User extends Equatable {
  final String id;
  final String email;
  final String? profileName;
  final String? profileIconUrl;
  final int isSubscribed;
  final SubscriptionDetails? subscriptionDetails;

  const User({
    required this.id,
    required this.email,
    this.profileName,
    this.profileIconUrl,
    this.isSubscribed = 0,
    this.subscriptionDetails,
  });

  User copyWith({
    String? id,
    String? email,
    String? profileName,
    String? profileIconUrl,
    int? isSubscribed,
    SubscriptionDetails? subscriptionDetails,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      profileName: profileName ?? this.profileName,
      profileIconUrl: profileIconUrl ?? this.profileIconUrl,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      subscriptionDetails: subscriptionDetails ?? this.subscriptionDetails,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final rawSub = json['is_subscribed'];
    int subVal = 0;
    if (rawSub is bool) {
      subVal = rawSub ? 1 : 0;
    } else if (rawSub is num) {
      subVal = rawSub.toInt();
    } else if (rawSub is String) {
      subVal = int.tryParse(rawSub) ?? 0;
    }

    return User(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      profileName: json['profile_name']?.toString(),
      profileIconUrl: json['profile_icon_url']?.toString(),
      isSubscribed: subVal,
      subscriptionDetails: json['subscription_details'] != null && json['subscription_details'] is Map<String, dynamic>
          ? SubscriptionDetails.fromJson(json['subscription_details'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'profile_name': profileName,
      'profile_icon_url': profileIconUrl,
      'is_subscribed': isSubscribed,
      'subscription_details': subscriptionDetails?.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, email, profileName, profileIconUrl, isSubscribed, subscriptionDetails];
}

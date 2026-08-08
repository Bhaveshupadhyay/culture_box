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
      subId: json['sub_id'] as String? ?? '',
      plan: json['plan'] as String? ?? '',
      expiry: json['expiry'] as String? ?? '',
      status: json['status'] as String? ?? 'expired',
      amount: json['amount'] as String? ?? '0.0',
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      profileName: json['profile_name'] as String?,
      profileIconUrl: json['profile_icon_url'] as String?,
      isSubscribed: json['is_subscribed'] as int? ?? 0,
      subscriptionDetails: json['subscription_details'] != null
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

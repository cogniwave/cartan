import 'package:flutter/material.dart';

class CardTypeData {
  // SIM Card fields
  final TextEditingController? iccidController;
  final TextEditingController? msisdnController;
  final TextEditingController? pinController;
  final TextEditingController? pukController;

  // Business card fields

  // Membership card fields

  // information card fields

  // Rewards card fields

  // Other card fields


  CardTypeData({
    // SIM Card
    this.iccidController,
    this.msisdnController,
    this.pinController,
    this.pukController,
  });

  // Factory constructors
  factory CardTypeData.forSim({
    TextEditingController? iccidController,
    TextEditingController? msisdnController,
    TextEditingController? pinController,
    TextEditingController? pukController,
  }) {
    return CardTypeData(
      iccidController: iccidController,
      msisdnController: msisdnController,
      pinController: pinController,
      pukController: pukController,
    );
  }
}
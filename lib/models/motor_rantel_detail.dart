class MotorRentalDetail {
  final int? employeeId;
  final int? motorRentalId;
  final int? totalGasoline;
  final double? totalWorkDay;
  final double? priceEngineOil;
  final double? priceMotorRental;
  final DateTime? startDateTaplab;
  final double? priceTaplabRental;
  final DateTime? resignedDate;
  final double? gasolinePricePerLiter;
  final double? amountPriceMotorRental;
  final double? amountPriceEngineOil;
  final double? amountPriceTaplabRental;
  final double? adjustAmountExclude;
  final double? adjustAmountTabpleExclude;
  final double? adjustAmountInclude;
  final double? adjustAmountTabpleInclude;
  final double? adjustAmountKh;
  final double? adjustAmountEngineOil;
  final int? taxRate;
  final DateTime? fromDate;
  final DateTime? toDate;

  MotorRentalDetail({
    this.employeeId,
    this.motorRentalId,
    this.totalGasoline,
    this.totalWorkDay,
    this.priceEngineOil,
    this.priceMotorRental,
    this.startDateTaplab,
    this.priceTaplabRental,
    this.resignedDate,
    this.gasolinePricePerLiter,
    this.amountPriceMotorRental,
    this.amountPriceEngineOil,
    this.amountPriceTaplabRental,
    this.adjustAmountExclude,
    this.adjustAmountTabpleExclude,
    this.adjustAmountInclude,
    this.adjustAmountTabpleInclude,
    this.adjustAmountKh,
    this.adjustAmountEngineOil,
    this.taxRate,
    this.fromDate,
    this.toDate,
  });

  factory MotorRentalDetail.fromJson(Map<String, dynamic> json) {
    return MotorRentalDetail(
      employeeId: _parseInt(json['employee_id']),
      motorRentalId: _parseInt(json['motor_rental_id']),
      totalGasoline: _parseInt(json['total_gasoline']),
      totalWorkDay: _parseDouble(json['total_work_day']),
      priceEngineOil: _parseDouble(json['price_engine_oil']),
      priceMotorRental: _parseDouble(json['price_motor_rentel']),
      startDateTaplab: _parseDate(json['start_date_taplab']),
      priceTaplabRental: _parseDouble(json['price_taplab_rentel']),
      resignedDate: _parseDate(json['resigned_date']),
      gasolinePricePerLiter: _parseDouble(json['gasoline_price_per_liter']),
      amountPriceMotorRental: _parseDouble(json['amount_price_motor_rentel']),
      amountPriceEngineOil: _parseDouble(json['amount_price_engine_oil']),
      amountPriceTaplabRental: _parseDouble(json['amount_price_taplab_rentel']),
      adjustAmountExclude: _parseDouble(json['adjust_amount_exclude']),
      adjustAmountTabpleExclude:
          _parseDouble(json['adjust_amount_tabple_exclude']),
      adjustAmountInclude: _parseDouble(json['adjust_amount_include']),
      adjustAmountTabpleInclude:
          _parseDouble(json['adjust_amount_tabple_include']),
      adjustAmountKh: _parseDouble(json['adjust_amount_kh']),
      adjustAmountEngineOil: _parseDouble(json['adjust_amount_engine_oil']),
      taxRate: _parseInt(json['tax_rate']),
      fromDate: _parseDate(json['from_date']),
      toDate: _parseDate(json['to_date']),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    return int.tryParse(value.toString());
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    return double.tryParse(value.toString());
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  @override
  String toString() {
    return 'MotorRentalDetail('
        'employeeId: $employeeId,'
        'motorRentalId: $motorRentalId,'
        'totalGasoline: $totalGasoline,'
        'totalWorkDay: $totalWorkDay,'
        'priceEngineOil: $priceEngineOil,'
        'priceMotorRental: $priceMotorRental,'
        'startDateTaplab: $startDateTaplab,'
        'priceTaplabRental: $priceTaplabRental,'
        'resignedDate: $resignedDate,'
        'gasolinePricePerLiter: $gasolinePricePerLiter,'
        'amountPriceMotorRental: $amountPriceMotorRental,'
        'amountPriceEngineOil: $amountPriceEngineOil,'
        'amountPriceTaplabRental: $amountPriceTaplabRental,'
        'adjustAmountExclude: $adjustAmountExclude,'
        'adjustAmountTabpleExclude: $adjustAmountTabpleExclude,'
        'adjustAmountInclude: $adjustAmountInclude,'
        'adjustAmountTabpleInclude: $adjustAmountTabpleInclude,'
        'adjustAmountKh: $adjustAmountKh,'
        'adjustAmountEngineOil: $adjustAmountEngineOil,'
        'taxRate: $taxRate,'
        'fromDate: $fromDate,'
        'toDate: $toDate,'
        ')';
  }
}

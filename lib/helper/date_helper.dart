import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

DateFormat localFormat = DateFormat('dd MMM y');
DateFormat dateStandar = DateFormat('yyyy-MM-dd');
DateFormat dateTransfer = DateFormat('yyyyMMdd');
DateFormat dateResult = DateFormat('dd/MM/yyyy');
DateFormat dateResi = DateFormat('EEEE, dd MMMM y, H:mm');
DateFormat datePeriode = DateFormat('yyyyMM');

DateFormat timeStandar = DateFormat('H:mm:ss');
DateFormat timeLocal = DateFormat('H:mm');
DateFormat timeTransfer = DateFormat('Hmm');

String localDate(String tgl) {
  initializeDateFormatting();

  localFormat = DateFormat('dd MMMM y', "id");

  String localDate = localFormat.format(DateTime.parse(tgl));

  return localDate;
}

String localTime(String tgl) {
  initializeDateFormatting();

  timeLocal = DateFormat('H:mm', "id");

  String localTime = timeLocal.format(DateTime.parse(tgl));

  return localTime;
}

String standarDate(DateTime date) {
  initializeDateFormatting();

  dateStandar = DateFormat('yyyy-MM-dd', "id");
  String converted = dateStandar.format(date);

  return converted;
}

String standarTime(DateTime date) {
  initializeDateFormatting();

  timeStandar = DateFormat('H:mm:ss', "id");
  String converted = timeStandar.format(date);

  return converted;
}

String transferDate(DateTime date) {
  initializeDateFormatting();

  dateTransfer = DateFormat('yyyyMMdd', "id");
  String converted = dateTransfer.format(date);

  return converted;
}

String transferTime(DateTime date) {
  initializeDateFormatting();

  timeTransfer = DateFormat('Hmm', "id");
  String converted = timeTransfer.format(date);

  return converted;
}

String resultDate(DateTime date) {
  initializeDateFormatting();

  dateResult = DateFormat('dd/MM/yyyy', "id");
  String converted = dateResult.format(date);

  return converted;
}

String resiDate(DateTime date) {
  initializeDateFormatting();

  dateResi = DateFormat('EEEE, dd MMMM y, H:mm', "id");
  String converted = dateResi.format(date);

  return converted;
}

String periodeDate(DateTime date) {
  initializeDateFormatting();

  datePeriode = DateFormat('yyyyMM', "id");
  String converted = datePeriode.format(date);

  return converted;
}

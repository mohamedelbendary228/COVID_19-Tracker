import 'package:coronavirus_rest_api_tracker_app/app/services/api.dart';
import 'package:coronavirus_rest_api_tracker_app/app/services/api_service.dart';
import 'package:flutter/cupertino.dart';

class EndpointsData {
  EndpointsData({@required this.values});
  final Map<Endpoint, EndpointData> values;

  EndpointData get cases => values[Endpoint.cases];
  EndpointData get casesSuspected => values[Endpoint.casesSuspected];
  EndpointData get casesConfirmed => values[Endpoint.casesConfirmed];
  EndpointData get deaths => values[Endpoint.deaths];
  EndpointData get recovered => values[Endpoint.recovered];
}

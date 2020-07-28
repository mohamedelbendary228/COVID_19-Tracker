import 'package:coronavirus_rest_api_tracker_app/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_tracker_app/app/services/api_service.dart';
import 'package:coronavirus_rest_api_tracker_app/app/services/data_cache_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import '../services/api.dart';

class DataRepository {
  DataRepository({@required this.apiService, @required this.dataCacheService});
  final APIService apiService;
  final DataCacheService dataCacheService;

  String _accessToken;

  Future<EndpointData> getEndpointData(Endpoint endpoint) async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      return await apiService.getEndpointData(
        accessToken: _accessToken,
        endpoint: endpoint,
      );
    } on Response catch (response) {
      // if unauthorization, get access token again
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await apiService.getEndpointData(
          accessToken: _accessToken,
          endpoint: endpoint,
        );
      }
      rethrow;
    }
  }

  Future<EndpointsData> getAllEndpointsData() async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }
      final endpointsData = await _getAllEndpointsData();
      // the next line saves the Endpoints in Shared Preferences
      await dataCacheService.setData(endpointsData);
      return endpointsData;
    } on Response catch (response) {
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        final endpointData = await _getAllEndpointsData();
        await dataCacheService.setData(endpointData);
        return endpointData;
      }
      rethrow;
    }
  }
  
  // get the Endpoints from Shared Preferences
  EndpointsData getAllEndpointsCacheData() => dataCacheService.getData();

  Future<EndpointsData> _getAllEndpointsData() async {
    final values = await Future.wait([
      apiService.getEndpointData(
        accessToken: _accessToken,
        endpoint: Endpoint.cases,
      ),
      apiService.getEndpointData(
        accessToken: _accessToken,
        endpoint: Endpoint.casesSuspected,
      ),
      apiService.getEndpointData(
        accessToken: _accessToken,
        endpoint: Endpoint.casesConfirmed,
      ),
      apiService.getEndpointData(
        accessToken: _accessToken,
        endpoint: Endpoint.deaths,
      ),
      apiService.getEndpointData(
        accessToken: _accessToken,
        endpoint: Endpoint.recovered,
      ),
    ]);
    return EndpointsData(values: {
      Endpoint.cases: values[0],
      Endpoint.casesSuspected: values[1],
      Endpoint.casesConfirmed: values[2],
      Endpoint.deaths: values[3],
      Endpoint.recovered: values[4],
    });
  }
}

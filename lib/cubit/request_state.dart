import '../models/request_model.dart'; 

abstract class RequestState {}

class RequestInitialState extends RequestState {}

class GetRequestsLoadingState extends RequestState {}
class GetRequestsSuccessState extends RequestState {
  final List<RequestModel> requests;
  GetRequestsSuccessState(this.requests);
}
class GetRequestsErrorState extends RequestState {
  final String error;
  GetRequestsErrorState(this.error);
}


class CreateRequestLoadingState extends RequestState {}
class CreateRequestSuccessState extends RequestState {
  final RequestModel request;
  CreateRequestSuccessState({required this.request}); 
}
class CreateRequestErrorState extends RequestState {
  final String error;
  CreateRequestErrorState(this.error);
}


class UpdateRequestLoadingState extends RequestState {}
class UpdateRequestSuccessState extends RequestState {
  final RequestModel updatedRequest;
  UpdateRequestSuccessState(this.updatedRequest);
}
class UpdateRequestErrorState extends RequestState {
  final String error;
  UpdateRequestErrorState(this.error);
}


class DeleteRequestLoadingState extends RequestState {}
class DeleteRequestSuccessState extends RequestState {}
class DeleteRequestErrorState extends RequestState {
  final String error;
  DeleteRequestErrorState(this.error);
}


class GetRequestStatsLoadingState extends RequestState {}
class GetRequestStatsSuccessState extends RequestState {
  final RequestStatsModel stats;
  GetRequestStatsSuccessState(this.stats);
}
class GetRequestStatsErrorState extends RequestState {
  final String error;
  GetRequestStatsErrorState(this.error);
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/closed_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/usecases/get_service_require_signature_survey_usecase.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/usecases/post_close_service_usecase.dart';
import 'package:help_desk/shared/services/token_service.dart';
import 'package:meta/meta.dart';

part 'service_requirements_event.dart';
part 'service_requirements_state.dart';

class ServiceRequirementsBloc extends Bloc<ServiceRequirementsEvent, ServiceRequirementsState> {
  final GetServiceRequireSignatureAndSurveyUsecase getServiceRequirementsUsecase;
  final PostCloseServiceUsecase postCloseServiceUsecase;
  final TokenService tokenService = TokenService();

  ServiceRequirementsBloc(this.getServiceRequirementsUsecase, this.postCloseServiceUsecase) : super(ServiceRequirementsInitial()) {
    on<GetServiceRequirements>(_getServiceRequirements);
    on<PostCloseService>(_postCloseService);
  }

  Future<void> _getServiceRequirements(GetServiceRequirements event, Emitter<ServiceRequirementsState> emit) async {
    emit(GettingServiceRequirements());
    try {
      Map<String, dynamic> data = await getServiceRequirementsUsecase.execute(event.serviceId);
      emit(ServiceRequirementsSuccess(data));
    } catch (e) {
      emit(ErrorGettingServiceRequirements(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }

  Future<void> _postCloseService(PostCloseService event, Emitter<ServiceRequirementsState> emit) async {
    emit(ClosingService());
    try {
      Map<String, dynamic> response = await postCloseServiceUsecase.execute(event.serviceData);
      emit(CloseServiceSuccess(response["pdfBase64"]));
    } catch (e) {
      emit(ErrorClosingService(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }
}

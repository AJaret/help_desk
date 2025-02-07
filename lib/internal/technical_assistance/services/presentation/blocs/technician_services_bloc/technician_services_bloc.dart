import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/usecases/get_technician_service_details_usecase.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/usecases/get_technician_services_usecase.dart';
import 'package:help_desk/shared/services/token_service.dart';
import 'package:meta/meta.dart';

part 'technician_services_event.dart';
part 'technician_services_state.dart';

class TechnicianServicesBloc extends Bloc<TechnicianServicesEvent, TechnicianServicesState> {
  final GetTechnicianServicesUsecase getTechnicianServicesUsecase;
  final GetTechnicianServiceDetailsUsecase getTechnicianServiceDetailsUsecase;
  final TokenService tokenService = TokenService();

  TechnicianServicesBloc(this.getTechnicianServicesUsecase, this.getTechnicianServiceDetailsUsecase) : super(TechnicianServicesInitial()) {
    on<GetTechnicianServices>(_getTechnicianServices);
    on<GetTechnicianServiceDetails>(_getTechnicianServiceDetails);
  }

  Future<void> _getTechnicianServices(GetTechnicianServices event, Emitter<TechnicianServicesState> emit) async {
    emit(GettingTechnicianServices());
    try {
      List<TechnicianService> data = await getTechnicianServicesUsecase.execute();
      emit(TechnicianServicesSuccess(data));
    } catch (e) {
      emit(ErrorGettingTechnicianServices(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }

  Future<void> _getTechnicianServiceDetails(GetTechnicianServiceDetails event, Emitter<TechnicianServicesState> emit) async {
    emit(GettingTechnicianServiceDetails());
    try {
      TechnicianService data = await getTechnicianServiceDetailsUsecase.execute(serviceId: event.serviceId);
      emit(TechnicianServiceDetailsSuccess(data));
    } catch (e) {
      emit(ErrorGettingTechnicianServices(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }
}

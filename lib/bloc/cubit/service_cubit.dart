import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit() : super(ServiceInitial());
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/get_home_data_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeCubit(this.getHomeDataUseCase) : super(HomeInitial());

  Future<void> getHomeData() async {
    emit(HomeLoading());

    try {
      final (products, categories) = await getHomeDataUseCase();

      emit(HomeSuccess(products: products, categories: categories));
    } catch (e) {
      emit(HomeError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_list_event.dart';
part 'search_list_state.dart';
part 'search_list_bloc.freezed.dart';

class SearchListBloc extends Bloc<SearchListEvent, SearchListState> {
  SearchListBloc() : super(const _Initial());
}

import 'package:equatable/equatable.dart';

class DetailState extends Equatable {
  final bool isSynopsisExpanded;

  const DetailState({
    this.isSynopsisExpanded = false,
  });

  DetailState copyWith({
    bool? isSynopsisExpanded,
  }) {
    return DetailState(
      isSynopsisExpanded: isSynopsisExpanded ?? this.isSynopsisExpanded,
    );
  }

  @override
  List<Object?> get props => [isSynopsisExpanded];
}

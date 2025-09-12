import 'package:ditonton/presentation/bloc/on_airing_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/on_airing_tv_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/state_enum.dart';
import '../../bloc/on_airing_tv_event.dart';
import '../../widgets/tv_card_list.dart';

class OnAiringTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/on-airing-tv';

  const OnAiringTvPage({super.key});

  @override
  _OnAiringTvPageState createState() => _OnAiringTvPageState();
}

class _OnAiringTvPageState extends State<OnAiringTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<OnAiringTvBloc>().add(FetchOnAiringTvs()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('On Airing TVs')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnAiringTvBloc, OnAiringTvState>(
          builder: (context, state) {
            if (state.state == RequestState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvs[index];
                  return TvCard(tv);
                },
                itemCount: state.tvs.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }
          },
        ),
      ),
    );
  }
}
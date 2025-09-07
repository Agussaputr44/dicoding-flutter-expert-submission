import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/state_enum.dart';
import '../../provider/tv_provider/on_airing_tv_notifier.dart';
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
      () => Provider.of<OnAiringTvNotifier>(
        context,
        listen: false,
      ).fetchOnAiringTvs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('On Airing Tvs')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<OnAiringTvNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final Tv = data.tvs[index];
                  return TvCard(Tv);
                },
                itemCount: data.tvs.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}

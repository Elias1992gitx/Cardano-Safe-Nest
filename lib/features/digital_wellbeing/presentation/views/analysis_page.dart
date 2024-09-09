import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safenest/core/common/app/views/loading_view.dart';
import 'package:safenest/features/dashboard/presentation/views/dashboard.dart';
import 'package:safenest/features/digital_wellbeing/presentation/bloc/digital_wellbeing_bloc.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/app_usage_chart.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/digital_wellbeing_chart.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/most_used_apps.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/screen_time_trend.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/usage_limit_card.dart';

class DigitalWellbeingAnalysisPage extends StatelessWidget {
  final String childId;

  const DigitalWellbeingAnalysisPage({Key? key, required this.childId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocBuilder<DigitalWellbeingBloc, DigitalWellbeingState>(
        builder: (context, state) {
          if (state is DigitalWellbeingLoading) {
            return const LoadingView();
          } else if (state is DigitalWellbeingLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DigitalWellbeingBloc>().add(GetDigitalWellbeingEvent(childId));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DigitalWellbeingSummary(digitalWellbeing: state.digitalWellbeing),
                      const SizedBox(height: 24),
                      AppUsageChart(appUsages: state.digitalWellbeing.appUsages),
                      const SizedBox(height: 24),
                      ScreenTimeTrend(history: state.digitalWellbeing.history),
                      const SizedBox(height: 24),
                      UsageLimitCard(
                        usageLimits: state.digitalWellbeing.usageLimits,
                        onSetLimit: (packageName, limit) {
                          context.read<DigitalWellbeingBloc>().add(
                            SetUsageLimitEvent(childId, packageName, limit),
                          );
                        },
                        onRemoveLimit: (packageName) {
                          context.read<DigitalWellbeingBloc>().add(
                            RemoveUsageLimitEvent(childId, packageName),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      MostUsedApps(appUsages: state.digitalWellbeing.appUsages),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is DigitalWellbeingError) {
            return Container();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/app/views/loading_view.dart';
import 'package:safenest/features/dashboard/presentation/views/dashboard.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/digital_wellbeing/presentation/bloc/digital_wellbeing_bloc.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/app_usage_chart.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/digital_wellbeing_chart.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/most_used_apps.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/screen_time_trend.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/usage_limit_card.dart';

class DigitalWellbeingAnalysisPage extends StatelessWidget {
  final String? childId;

  const DigitalWellbeingAnalysisPage({Key? key, this.childId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildFancyAppBar(context),

      body: childId == null
          ? _buildDefaultGraphs(context)
          : _buildChildSpecificGraphs(context),
    );
  }

  Widget _buildDefaultGraphs(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigitalWellbeingSummary(),
            const SizedBox(height: 24),
            AppUsageChart(),
            const SizedBox(height: 24),
            ScreenTimeTrend(),
            const SizedBox(height: 24),
            UsageLimitCard(
              usageLimits: null,
              onSetLimit: (_, __) {},
              onRemoveLimit: (_) {},
            ),
            const SizedBox(height: 24),
            MostUsedApps(),
          ],
        ),
      ),
    );
  }

  Widget _buildChildSpecificGraphs(BuildContext context) {
    return BlocBuilder<DigitalWellbeingBloc, DigitalWellbeingState>(
      builder: (context, state) {
        if (state is DigitalWellbeingLoading) {
          return const LoadingView();
        } else if (state is DigitalWellbeingLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DigitalWellbeingBloc>().add(GetDigitalWellbeingEvent(childId!));
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
                          SetUsageLimitEvent(childId!, packageName, UsageLimit(
                            packageName: packageName,
                            dailyLimit: limit,
                            isEnabled: true,
                          )),
                        );
                      },
                      onRemoveLimit: (packageName) {
                        context.read<DigitalWellbeingBloc>().add(
                          RemoveUsageLimitEvent(childId!, packageName),
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
    );
  }

  PreferredSizeWidget _buildFancyAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Digital Wellbeing',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                _buildChildDropdown(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildDropdown(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: childId,
          hint: Text(
            'Select Child',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
          items: [
            DropdownMenuItem(value: null, child: Text('All Children')),
            // Add more DropdownMenuItem widgets for each child
          ],
          onChanged: (String? newValue) {
            // Handle child selection
          },
        ),
      ),
    );
  }
}


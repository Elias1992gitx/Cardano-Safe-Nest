import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/app/views/loading_view.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/digital_wellbeing_chart.dart'
    as digital_wellbeing;
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/digital_wellbeing/presentation/bloc/digital_wellbeing_bloc.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/app_usage_chart.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/most_used_apps.dart';

import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/screen_time_trend.dart';
import 'package:safenest/features/digital_wellbeing/presentation/widget/usage_limit_card.dart';
import 'package:safenest/features/profile/presentation/bloc/parental_info_bloc.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';

class DigitalWellbeingAnalysisPage extends StatefulWidget {
  final String? childId;

  const DigitalWellbeingAnalysisPage({Key? key, this.childId})
      : super(key: key);

  @override
  _DigitalWellbeingAnalysisPageState createState() =>
      _DigitalWellbeingAnalysisPageState();
}

class _DigitalWellbeingAnalysisPageState
    extends State<DigitalWellbeingAnalysisPage> {
  List<Child> children = [];
  String? selectedChildId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    context
        .read<DigitalWellbeingBloc>()
        .add(const GetCurrentUserDigitalWellbeingEvent());
    context.read<ParentalInfoBloc>().add(GetParentalInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ParentalInfoBloc, ParentalInfoState>(
      listener: (context, state) {
        if (state is ParentalInfoLoaded) {
          setState(() {
            children = state.parentalInfo.children;
          });
        }
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [_buildSliverAppBar(context)];
          },
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: selectedChildId == null
                ? _buildCurrentUserGraphs(context)
                : _buildChildSpecificGraphs(context),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    if (selectedChildId != null) {
      context
          .read<DigitalWellbeingBloc>()
          .add(GetDigitalWellbeingEvent(selectedChildId!));
    } else {
      context
          .read<DigitalWellbeingBloc>()
          .add(const GetCurrentUserDigitalWellbeingEvent());
    }
  }

  Widget _buildCurrentUserGraphs(BuildContext context) {
    return BlocBuilder<DigitalWellbeingBloc, DigitalWellbeingState>(
      builder: (context, state) {
        if (state is DigitalWellbeingLoading) {
          return const LoadingView();
        } else if (state is DigitalWellbeingLoaded) {
          return _buildGraphs(context, state.digitalWellbeing);
        } else if (state is DigitalWellbeingError) {
          return _buildErrorView(context, state.message);
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget _buildChildSpecificGraphs(BuildContext context) {
    return BlocBuilder<DigitalWellbeingBloc, DigitalWellbeingState>(
      builder: (context, state) {
        if (state is DigitalWellbeingLoading) {
          return const LoadingView();
        } else if (state is DigitalWellbeingLoaded) {
          return _buildGraphs(context, state.digitalWellbeing);
        } else if (state is DigitalWellbeingError) {
          return _buildErrorView(context, state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGraphs(BuildContext context, DigitalWellbeing digitalWellbeing) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            digital_wellbeing.DigitalWellbeingSummary(
                digitalWellbeing: digitalWellbeing),
            const SizedBox(height: 24),
            AppUsageChart(appUsages: digitalWellbeing.appUsages),
            const SizedBox(height: 24),
            UsageLimitCard(
              appUsages: digitalWellbeing.appUsages,
              usageLimits: digitalWellbeing.usageLimits,
              onSetLimit: _handleSetLimit,
              onRemoveLimit: _handleRemoveLimit,
            ),
            const SizedBox(height: 24),
            MostUsedApps(appUsages: digitalWellbeing.appUsages),
          ],
        ),
      ),
    );
  }

  void _handleSetLimit(String packageName, Duration limit) {
    if (selectedChildId != null) {
      context.read<DigitalWellbeingBloc>().add(
            SetUsageLimitEvent(
              selectedChildId!,
              packageName,
              UsageLimit(
                packageName: packageName,
                dailyLimit: limit,
                isEnabled: true,
              ),
            ),
          );
    }
  }

  void _handleRemoveLimit(String packageName) {
    if (selectedChildId != null) {
      context.read<DigitalWellbeingBloc>().add(
            RemoveUsageLimitEvent(selectedChildId!, packageName),
          );
    }
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $message'),
          ElevatedButton(
            onPressed: _refreshData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Digital Wellbeing',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: _buildChildDropdown(context),
        ),
      ],
    );
  }

  Widget _buildChildDropdown(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedChildId,
          hint: Text(
            'Select Child',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
          items: [
            const DropdownMenuItem(value: null, child: Text('All Children')),
            ...children.map(
              (child) => DropdownMenuItem(
                value: child.id,
                child: Text(child.name),
              ),
            ),
          ],
          onChanged: (String? newValue) {
            setState(() {
              selectedChildId = newValue;
            });
            if (newValue != null) {
              context
                  .read<DigitalWellbeingBloc>()
                  .add(GetDigitalWellbeingEvent(newValue));
            } else {
              context
                  .read<DigitalWellbeingBloc>()
                  .add(const GetCurrentUserDigitalWellbeingEvent());
            }
          },
        ),
      ),
    );
  }
}

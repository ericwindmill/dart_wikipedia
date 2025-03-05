import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/features/on_this_day/timeline_view_model.dart';
import 'package:flutter_app/providers/breakpoint_provider.dart';
import 'package:flutter_app/ui/app_localization.dart';
import 'package:flutter_app/ui/build_context_util.dart';
import 'package:flutter_app/ui/shared_widgets/filter_dialog.dart';
import 'package:flutter_app/ui/shared_widgets/timeline/timeline.dart';
import 'package:flutter_app/ui/theme/theme.dart';
import 'package:wikipedia/wikipedia.dart';

class TimelinePageView extends StatelessWidget {
  const TimelinePageView({required this.viewModel, super.key});

  final TimelineViewModel viewModel;

  Widget filterAction(BuildContext context) {
    return IconButton(
      icon: Icon(
        color: AppColors.primary,
        context.isCupertino
            ? CupertinoIcons.slider_horizontal_3
            : Icons.filter_alt_outlined,
      ),
      onPressed:
          () async => showAdaptiveDialog(
            context: context,
            barrierColor: Colors.transparent,
            builder: (BuildContext context) {
              return FilterDialog<EventType>(
                options: viewModel.selectEventTypes.value,
                onSelectItem:
                    ({required EventType value, bool? isChecked}) =>
                        viewModel.toggleSelectedType(
                          isChecked: isChecked ?? false,
                          type: value,
                        ),
                onSubmit: viewModel.filterEvents,
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            if (context.isCupertino)
              CupertinoSliverNavigationBar(
                largeTitle: Text(AppStrings.onThisDay),
                trailing: filterAction(context),
              )
            else
              const SliverAppBar(title: Text('Title')),
          ];
        },
        body: ListenableBuilder(
          listenable: viewModel,
          builder: (BuildContext context, _) {
            if (viewModel.hasError) {
              return Center(child: Text(viewModel.error!));
            }
            if (!viewModel.hasData && !viewModel.hasError) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            return ColoredBox(
              color: Colors.white,
              child: ListView.builder(
                itemCount: viewModel.filteredEvents.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.all(
                        BreakpointProvider.of(context).margin,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            viewModel.readableDate,
                            style: context.titleMedium.copyWith(fontSize: 24),
                          ),
                          SizedBox(
                            height: BreakpointProvider.of(context).spacing,
                          ),
                          Text(
                            AppStrings.historicEvents(
                              viewModel.filteredEvents.length.toString(),
                            ).toUpperCase(),
                            style: context.titleMedium.copyWith(
                              color: AppColors.labelOnLight,
                            ),
                          ),
                          if (viewModel.readableYearRange != '')
                            Text(
                              AppStrings.yearRange(viewModel.readableYearRange),
                              style: context.titleMedium.copyWith(
                                color: AppColors.labelOnLight,
                              ),
                            ),
                          SizedBox(
                            height: BreakpointProvider.of(context).spacing,
                          ),
                        ],
                      ),
                    );
                  }

                  final OnThisDayEvent event =
                      viewModel.filteredEvents[index - 1];
                  return TimelineListItem(event: event);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

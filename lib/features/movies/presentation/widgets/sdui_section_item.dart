import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../app/di/service_locator.dart';
import '../../../../core/models/enums.dart';
import '../../../../core/models/layout_models.dart';
import '../bloc/section_cubit.dart';
import 'hero_carousel.dart';
import 'movie_card.dart';
import 'movie_section.dart';

class SduiSectionItem extends StatefulWidget {
  final LayoutSectionModel section;

  const SduiSectionItem({
    super.key,
    required this.section,
  });

  @override
  State<SduiSectionItem> createState() => _SduiSectionItemState();
}

class _SduiSectionItemState extends State<SduiSectionItem> {
  late final SectionCubit _sectionCubit;

  @override
  void initState() {
    super.initState();
    _sectionCubit = SectionCubit(ServiceLocator.instance.moviesRepository);
    final endpoint = widget.section.dataEndpoint ?? widget.section.sectionId;
    _sectionCubit.fetchSectionData(endpoint);
  }

  @override
  void dispose() {
    _sectionCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _sectionCubit,
      child: BlocBuilder<SectionCubit, SectionState>(
        builder: (context, state) {
          if (state is SectionLoading) {
            return _buildLoadingWidget();
          }

          if (state is SectionError) {
            return _buildErrorWidget(state.message);
          }

          if (state is SectionEmpty) {
            return const SizedBox.shrink();
          }

          if (state is SectionLoaded) {
            final movies = state.movies;
            if (movies.isEmpty) return const SizedBox.shrink();

            // SDUI Widget Resolution using WidgetType Enum
            switch (widget.section.widgetType) {
              case WidgetType.heroCarousel:
                return HeroCarousel(movies: movies);

              case WidgetType.horizontalList:
                return MovieSection(
                  title: widget.section.sectionName,
                  movies: movies,
                );

              case WidgetType.verticalList:
              case WidgetType.grid:
                return Padding(
                  padding: AppSpacing.all16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.section.sectionName.toUpperCase(),
                        style: AppTextStyles.sectionHeader,
                      ),
                      AppSpacing.vGap12,
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: AppSpacing.px12,
                          mainAxisSpacing: AppSpacing.px12,
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return MovieCard(
                            movie: movies[index],
                            width: double.infinity,
                            height: double.infinity,
                          );
                        },
                      ),
                      AppSpacing.vGap16,
                    ],
                  ),
                );

              case WidgetType.unknown:
                return MovieSection(
                  title: widget.section.sectionName,
                  movies: movies,
                );
            }
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    if (widget.section.widgetType == WidgetType.heroCarousel) {
      return Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.surfaceSecondary,
        child: Container(
          height: AppSpacing.px520,
          width: double.infinity,
          color: AppColors.surface,
        ),
      );
    }

    return Padding(
      padding: AppSpacing.all16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.section.sectionName.toUpperCase(),
            style: AppTextStyles.sectionHeader,
          ),
          AppSpacing.vGap12,
          SizedBox(
            height: AppSpacing.px205,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) => Shimmer.fromColors(
                baseColor: AppColors.surface,
                highlightColor: AppColors.surfaceSecondary,
                child: Container(
                  width: 144,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Padding(
      padding: AppSpacing.all16,
      child: Container(
        padding: AppSpacing.all16,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.px8),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent),
            AppSpacing.hGap12,
            Expanded(
              child: Text(
                'Failed to load ${widget.section.sectionName}',
                style: AppTextStyles.bodySmall,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.logoGold),
              onPressed: () {
                final endpoint = widget.section.dataEndpoint ?? widget.section.sectionId;
                _sectionCubit.fetchSectionData(endpoint);
              },
            ),
          ],
        ),
      ),
    );
  }
}

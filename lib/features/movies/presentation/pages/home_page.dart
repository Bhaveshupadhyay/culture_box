import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/culturebox_logo.dart';
import '../../../../core/widgets/custom_drawer.dart';
import '../bloc/homepage_layout_bloc.dart';
import '../widgets/sdui_section_item.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomepageLayoutBloc _homepageLayoutBloc;

  @override
  void initState() {
    super.initState();
    _homepageLayoutBloc = ServiceLocator.instance.homepageLayoutBloc;
    _homepageLayoutBloc.add(const FetchHomepageLayout());
  }

  Future<void> _onRefresh() async {
    _homepageLayoutBloc.add(const FetchHomepageLayout());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homepageLayoutBloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: const CultureBoxLogo(),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
            ),
            AppSpacing.hGap8,
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.logoGold,
          backgroundColor: AppColors.surface,
          child: BlocBuilder<HomepageLayoutBloc, HomepageLayoutState>(
            builder: (context, state) {
              if (state is HomepageLayoutLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.logoGold,
                  ),
                );
              }

              if (state is HomepageLayoutError) {
                return Center(
                  child: Padding(
                    padding: AppSpacing.all24,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_off, size: 64, color: Colors.white38),
                        AppSpacing.vGap16,
                        Text(
                          'Unable to Load Homepage',
                          style: AppTextStyles.emptyStateTitle,
                        ),
                        AppSpacing.vGap8,
                        Text(
                          state.message,
                          style: AppTextStyles.emptyStateSubtitle,
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.vGap24,
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.logoRedOrange,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            _homepageLayoutBloc.add(const FetchHomepageLayout());
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is HomepageLayoutLoaded) {
                final sections = state.sections;

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...sections.map(
                        (section) => SduiSectionItem(
                          key: ValueKey(section.sectionId),
                          section: section,
                        ),
                      ),
                      AppSpacing.vGap30,
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

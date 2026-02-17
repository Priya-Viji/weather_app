import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:weather_app/core/constants/app_constants.dart';
import 'package:weather_app/bloc/city_search/city_search_bloc.dart';
import 'package:weather_app/bloc/city_search/city_search_event.dart';
import 'package:weather_app/bloc/city_search/city_search_state.dart';
import 'package:weather_app/screens/weather_screen.dart';

class CityInputScreen extends StatelessWidget {
  CityInputScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? AppConstants.darkGradient
        : AppConstants.lightGradient;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildSearchResultsSection(context)),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HEADER SECTION ----------------

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Language Switcher
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "WeatherReport".tr(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "FindYourCity".tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),

              // Language Switcher
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.language_rounded, color: Colors.white),
                  onSelected: (value) => context.setLocale(Locale(value)),
                  itemBuilder: (context) => AppConstants.supportedLanguages
                      .map(
                        (lang) => PopupMenuItem(
                          value: lang['code'],
                          child: Row(
                            children: [
                              Text(lang['flag'] ?? '🌍'),
                              const SizedBox(width: 12),
                              Text(lang['label']!),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Search Bar
          _buildSearchBar(context),
        ],
      ),
    );
  }

  // ---------------- SEARCH BAR ----------------

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          context.read<CitySearchBloc>().add(SearchCityEvent(value));
        },
        decoration: InputDecoration(
          hintText: "enterCity".tr(),
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () {
                    _controller.clear(); //Clear the text field
                    FocusScope.of(context).unfocus(); // Hide the keyboard
                    context.read<CitySearchBloc>().add(SearchCityEvent("")); //Reset search results
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  // ---------------- SEARCH RESULTS SECTION ----------------

  Widget _buildSearchResultsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: BlocBuilder<CitySearchBloc, CitySearchState>(
        builder: (context, state) {
          if (state.loading) return _buildLoadingState();
          if (state.error == "NO_INTERNET") {
            return _buildNoInternetState(context);
          }
          if (state.results.isEmpty) return _buildEmptyState(context);

          return _buildResultsList(context, state.results);
        },
      ),
    );
  }

  // ---------------- LOADING UI ----------------

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 20),
          Text(
            "searchingCities".tr(),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // ---------------- EMPTY UI ----------------

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        "startTyping".tr(),
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  // ---------------- NO INTERNET UI ----------------

  Widget _buildNoInternetState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            "noInternet".tr(),
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            "checkConnection".tr(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
            ), // white color 80% visible 20% transparent
          ),
        ],
      ),
    );
  }

  // ---------------- RESULTS LIST ----------------

  Widget _buildResultsList(BuildContext context, List<dynamic> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final city = results[index];
        final cityName = city['name'] ?? '';
        final state = city['state'] ?? '';
        final country = city['country'] ?? '';

        return _buildCityCard(context, cityName, state, country);
      },
    );
  }

  // ---------------- CITY CARD ----------------

  Widget _buildCityCard(
    BuildContext context,
    String city,
    String state,
    String country,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: const Icon(Icons.location_on_rounded, color: Colors.blue),
        title: Text(state.isNotEmpty ? "$city, $state" : city),
        subtitle: Text(country),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => WeatherScreen(city: city)),
          );
        },
      ),
    );
  }
}

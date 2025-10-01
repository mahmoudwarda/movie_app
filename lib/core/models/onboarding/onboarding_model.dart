class OnboardingData {
  final String image;
  final String title;
  final String? subtitle;

  OnboardingData({
    required this.image,
    required this.title,
    this.subtitle,
  });
}

final List<OnboardingData> onboardingPages = [
  OnboardingData(
    image: "assets/images/OnBoarding.png",
    title: "Find Your Next Favorite Movie Here",
    subtitle: "Get access to a huge library of movies to suit all tastes.",
  ),
  OnboardingData(
    image: "assets/images/OnBoarding2.png",
    title: "Discover Movies",
    subtitle: "Explore a vast collection of movies in all qualities and genres.",
  ),
  OnboardingData(
    image: "assets/images/OnBoarding_3.png",
    title: "Explore All Genres",
    subtitle: "Find something new and exciting to watch every day.",
  ),
  OnboardingData(
    image: "assets/images/OnBoarding_4.png",
    title: "Create Watchlist",
    subtitle: "Save movies to your watchlist to keep track of what you want.",
  ),
  OnboardingData(
    image: "assets/images/OnBoarding_5.png",
    title: "Rate, Review, and Learn",
    subtitle: "Share your thoughts and help others discover great movies.",
  ),
  OnboardingData(
    image: "assets/images/OnBoarding_6.png",
    title: "Start Watching Now",
  ),
];

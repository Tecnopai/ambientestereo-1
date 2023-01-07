import 'onboarding_model.dart';

class OnboardingData {
  static List<OnboardingModel> allBoards = [
    OnboardingModel(
      title: 'Hola, estas en Ambiente Stereo 88.4FM',
      description:
          'Aquí encontrarás nuestra emisora Online, Música para Dios, predicaciones, noticias, actualidad',
      imageLocation: 'assets/animations/animation_hello.json',
    ),
    OnboardingModel(
      title: 'Información valiosa para tu diario vivir',
      description:
          'Reproduce Ambiente Stereo 88.4FM mientras conoces sobre la actualidad nacional e internacional',
      imageLocation: 'assets/animations/animation_handpicked.json',
    ),
    OnboardingModel(
      title: 'Elije un diseño claro u oscuro',
      description:
          'Guarda las novedades o noticias que más te llamen la atención',
      imageLocation: 'assets/animations/animation_update.json',
    ),
  ];
}

import 'package:equatable/equatable.dart';
import 'package:safenest/core/res/media_res.dart';
import 'package:safenest/core/utils/constants.dart';

class CreateProfilePageContent extends Equatable {
  const CreateProfilePageContent({required this.title, required this.description});
  const CreateProfilePageContent.first()
      : this(
          title: 'Continue your Safe Nest Story!',
          description: 'You are just a few steps away from creating a safe digital environment for your child. '
              "Complete your parental profile now to start monitoring and protecting them online.",

        );
  const CreateProfilePageContent.second()
      : this(
          title: "Let's get started! First, tell us a little about "
              'your business.',
          description:
              '',
        );
  const CreateProfilePageContent.third()
      : this(
          title: "To get started tell us where you're located",
          description: '',
        );
  final String title;
  final String description;

  @override
  List<Object?> get props => [title, description];
}

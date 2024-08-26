import 'package:equatable/equatable.dart';
import 'package:safenest/core/res/media_res.dart';
import 'package:safenest/core/utils/constants.dart';

class PageContent extends Equatable {
  const PageContent(
      {required this.image, required this.title, required this.description});
  const PageContent.first()
      : this(
            image: MediaRes.onBoardingImg1,
            title: "Ensure Your Child's Safety Online",
            description:
                'Monitor your kids\' online activity with confidence using $kAppName’s comprehensive tools, '
                'keeping them safe across platforms.');

  const PageContent.second()
      : this(
          image: MediaRes.onBoardingImg2,
          title: 'Real-Time Alerts, Anytime, Anywhere',
          description:
              'Stay informed with instant notifications and manage your child’s safety efficiently from a single dashboard with $kAppName.',
        );

  const PageContent.third()
      : this(
          image: MediaRes.onBoardingImg3,
          title: 'Security and Innovation Combined',
          description:
              '$kAppName is designed to protect your children online and in the real world, providing peace of mind with advanced features.',
        );
  final String image;
  final String title;
  final String description;

  @override
  List<Object?> get props => [image, title, description];
}

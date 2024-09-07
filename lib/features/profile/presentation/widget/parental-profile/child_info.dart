import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:safenest/core/common/widgets/dashed_paint.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';

class ChildInfo extends StatefulWidget {
  final Function(Child) onChildAdded;

  final List<Child> children;

  const ChildInfo({super.key, required this.onChildAdded, required this.children});

  @override
  State<ChildInfo> createState() => _ChildInfoState();
}

class _ChildInfoState extends State<ChildInfo> {
  final List<Child> _children = [];

  @override
  void initState() {
    super.initState();

  }

  void _addChild() {
  context.push('/profile-screen/parental-mode/add-child', extra: (Child child) {
    setState(() {
      _children.add(child);
    });
    widget.onChildAdded(child);
  });
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top: 50),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
                child: Text(
                  "Let's get started! First, tell us a little about your child.",
                  style: GoogleFonts.plusJakartaSans(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10, // Add spacing between rows
                  crossAxisSpacing: 10, // Add spacing between columns
                ),
                itemCount: _children.length + 1,
                itemBuilder: (context, index) {
                  if (index == widget.children.length) {
                    return _buildAddChildButton(context);
                  } else {
                    final child = widget.children[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        border: Border.all(color: context.theme.primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(child.name, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w500)),
                          Text('Age: ${child.age}', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                          Text('Gender: ${child.gender}', style: GoogleFonts.plusJakartaSans(fontSize: 12)),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddChildButton(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      child: DashedBorderContainer(
        borderColor: context.theme.primaryColor,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: _addChild,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    const Icon(
                      IconlyLight.profile,
                      size: 45,
                    ),
                    Icon(
                      IconlyBold.star,
                      size: 28,
                      color: context.theme.primaryColor,
                    ),
                  ],
                ),
                Text(
                  "Add Child",
                  style: GoogleFonts.plusJakartaSans(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:huops/constants/app_strings.dart';
import 'package:huops/models/category.dart';
import 'package:huops/widgets/cards/custom.visibility.dart';
import 'package:huops/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    required this.category,
    required this.onPressed,
    this.maxLine = true,
    this.h,
    Key? key,
  }) : super(key: key);

  final Function(Category) onPressed;
  final Category category;
  final bool maxLine;
  final double? h;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //max line applied
        CustomVisibilty(
          visible: maxLine,
          child: VStack(
            [
              //
              CustomImage(
                imageUrl: category.imageUrl ?? "",
                boxFit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.5,
                height: 200,
              )
                  .box
                  .roundedSM
                  .clip(Clip.antiAlias)
                  .color(Vx.hexToColor(category.color ?? "#ffffff"))
                  .make()
                  .py2(),

              category.name.text
                  .minFontSize(AppStrings.categoryTextSize)
                  .size(AppStrings.categoryTextSize)
                  .center
                  .maxLines(1)
                  .overflow(TextOverflow.ellipsis)
                  .make()
                  .p2()
                  .expand(),
            ],
            crossAlignment: CrossAxisAlignment.center,
            alignment: MainAxisAlignment.start,
          )

              .h(h ??
                  ((AppStrings.categoryImageHeight * 1.8) +
                      AppStrings.categoryImageHeight))
              .onInkTap(
                () => this.onPressed(this.category),
              )
              .px4(),
        ),

        //no max line applied
        CustomVisibilty(
          visible: !maxLine,
          child: VStack(
            [
              //
              CustomImage(
                imageUrl: category.imageUrl ?? "",
                boxFit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.5,
                height: 120,
              )
                  .box
                  .roundedSM
                  .clip(Clip.antiAlias)
                  .color(Vx.hexToColor(category.color ?? "#ffffff"))
                  .make()
                  .py2(),

              //
              category.name.text
                  .size(AppStrings.categoryTextSize)
                  .wrapWords(true)
                  .center
                  .make()
                  .p2(),
            ],
            crossAlignment: CrossAxisAlignment.center,
            alignment: MainAxisAlignment.start,
          )

              .onInkTap(
                () => this.onPressed(this.category),
              )
              .px4(),
        )

        //
      ],
    );
  }
}

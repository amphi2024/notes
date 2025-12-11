import 'package:amphi/utils/color_values.dart';
import 'package:amphi/models/app.dart';
import 'package:amphi/widgets/color/picker/color_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/bottom_sheet_drag_handle.dart';
import 'package:notes/components/note_editor/edit_style/edit_note_font.dart';
import 'package:notes/components/note_editor/edit_style/edit_note_text_size.dart';
import 'package:notes/components/note_editor/edit_style/toggle_attribute_button.dart';
import 'package:notes/components/note_editor/editor_extension.dart';
import 'package:notes/models/app_colors.dart';
import 'package:notes/models/theme_model.dart';
import 'package:notes/icons/icons.dart';
import 'package:notes/providers/editing_note_provider.dart';

class EditNoteTextStyle extends ConsumerStatefulWidget {

  final QuillController controller;

  const EditNoteTextStyle({
    super.key,
    required this.controller
  });

  @override
  ConsumerState<EditNoteTextStyle> createState() => _EditNoteTextStyleState();
}

class _EditNoteTextStyleState extends ConsumerState<EditNoteTextStyle> {
  void addNoteTextColor(Color color) {
    appColors.noteTextColors.add(color);
    appColors.save();
  }

  void removeNoteTextColor(Color color) {
    appColors.noteTextColors.remove(color);
    appColors.save();
  }

  Color selectionBackgroundColorToIconColor() {
    Color? backgroundColor = widget.controller.selectionBackgroundColor();
    if (backgroundColor != null) {
      if (backgroundColor.a < 0.1) {
        return Theme
            .of(context)
            .cardColor;
      } else {
        return backgroundColor;
      }
    } else {
      return Theme
          .of(context)
          .cardColor;
    }
  }

  bool attributeApplied(Attribute attribute) =>
      widget.controller.getSelectionStyle().containsKey(attribute.key);

  bool listAttributeApplied(Attribute attribute) =>
      widget.controller
          .getSelectionStyle()
          .attributes["list"]?.value == attribute.value;

  bool alignAttributeApplied(Attribute attribute) =>
      widget.controller
          .getSelectionStyle()
          .attributes["align"]?.value == attribute.value;

  void toggleAttribute(Attribute attribute) {
    setState(() {
      widget.controller.skipRequestKeyboard = attribute.isInline;
      if (attributeApplied(attribute)) {
        widget.controller.formatSelection(Attribute.clone(attribute, null));
      } else {
        widget.controller.formatSelection(attribute);
      }
    });
  }

  bool headerAttributeApplied(Attribute headerAttribute) {
    return widget.controller
        .getSelectionStyle()
        .attributes["header"]?.value == headerAttribute.value;
  }

  void toggleHeaderAttribute(Attribute attribute) {
    setState(() {
      widget.controller.skipRequestKeyboard = attribute.isInline;
      if (headerAttributeApplied(attribute)) {
        widget.controller.formatSelection(Attribute.clone(attribute, null));
      } else {
        widget.controller.formatSelection(attribute);
      }
    });
  }

  void toggleListAttribute(Attribute attribute) {
    setState(() {
      widget.controller.skipRequestKeyboard = attribute.isInline;
      if (listAttributeApplied(attribute)) {
        widget.controller.formatSelection(Attribute.clone(attribute, null));
      } else {
        widget.controller.formatSelection(attribute);
      }
    });
  }

  void toggleAlignAttribute(Attribute attribute) {
    setState(() {
      widget.controller.skipRequestKeyboard = attribute.isInline;
      if (alignAttributeApplied(attribute)) {
        widget.controller.formatSelection(
            Attribute(attribute.key, AttributeScope.inline, null));
      } else {
        widget.controller.formatSelection(attribute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final note = ref.watch(editingNoteProvider).note;
    final themeData = Theme.of(context);
    return Container(
      height: App.isDesktop() ? 250 : 400,
      width: double.infinity,
      decoration: BoxDecoration(color: themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Visibility(
            visible: !App.isWideScreen(context),
            child: const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: BottomSheetDragHandle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ToggleAttributeButton(
                  activated: headerAttributeApplied(Attribute.h1),
                  icon: AppIcons.h1,
                  onPressed: () => toggleHeaderAttribute(Attribute.h1),
                ),
                ToggleAttributeButton(
                  activated: headerAttributeApplied(Attribute.h2),
                  icon: AppIcons.h2,
                  onPressed: () => toggleHeaderAttribute(Attribute.h2),
                ),
                ToggleAttributeButton(
                  activated: headerAttributeApplied(Attribute.h3),
                  icon: AppIcons.h3,
                  onPressed: () => toggleHeaderAttribute(Attribute.h3),
                ),
                ToggleAttributeButton(
                  activated: headerAttributeApplied(Attribute.h4),
                  icon: AppIcons.h4,
                  onPressed: () => toggleHeaderAttribute(Attribute.h4),
                ),
                ToggleAttributeButton(
                  activated: headerAttributeApplied(Attribute.h5),
                  icon: AppIcons.h5,
                  onPressed: () => toggleHeaderAttribute(Attribute.h5),
                ),
                ToggleAttributeButton(
                  activated: headerAttributeApplied(Attribute.h6),
                  icon: AppIcons.h6,
                  onPressed: () => toggleHeaderAttribute(Attribute.h6),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ToggleAttributeButton(
                  activated: attributeApplied(Attribute.bold),
                  icon: Icons.format_bold,
                  onPressed: () => toggleAttribute(Attribute.bold),
                ),
                ToggleAttributeButton(
                  activated: attributeApplied(Attribute.italic),
                  icon: Icons.format_italic,
                  onPressed: () => toggleAttribute(Attribute.italic),
                ),
                ToggleAttributeButton(
                  activated: attributeApplied(Attribute.underline),
                  icon: Icons.format_underline,
                  onPressed: () => toggleAttribute(Attribute.underline),
                ),
                ToggleAttributeButton(
                  activated: attributeApplied(Attribute.strikeThrough),
                  icon: Icons.format_strikethrough,
                  onPressed: () => toggleAttribute(Attribute.strikeThrough),
                ),
                IconButton(
                    onPressed: () {
                      showAdaptiveColorPicker(
                          context: context,
                          color: widget.controller.currentTextColor(context),
                          onAddColor: addNoteTextColor,
                          onColorChanged: (color) {
                            toggleAttribute(ColorAttribute(color
                                .toHexString()));
                          },
                          colors: appColors.noteTextColors,
                          onRemoveColor: removeNoteTextColor,
                          defaultColor: themeData.textTheme.bodyMedium!.color,
                          onDefaultColorTap: (color) {
                            toggleAttribute(Attribute.color);
                          });
                    },
                    icon: const Icon(
                      Icons.color_lens,
                      size: 30,
                    )),
                Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: themeData.colorScheme.primary,
                              disabledForegroundColor: ThemeModel.transparent,
                              disabledBackgroundColor: ThemeModel.transparent,
                              surfaceTintColor: ThemeModel.transparent,
                              foregroundColor: ThemeModel.transparent,
                              shadowColor: ThemeModel.transparent),
                          onPressed: () {
                            showAdaptiveColorPicker(
                                context: context,
                                color: widget.controller
                                    .selectionBackgroundColor() ??
                                    ThemeModel.transparent,
                                onAddColor: addNoteTextColor,
                                onColorChanged: (color) {
                                  setState(() {
                                    widget.controller.formatSelection(
                                        BackgroundAttribute(
                                            color.toHexString()));
                                  });
                                },
                                colors: AppColors
                                    .getInstance()
                                    .noteTextColors,
                                onRemoveColor: removeNoteTextColor,
                                defaultColor: ThemeModel.transparent,
                                onDefaultColorTap: (color) {
                                  toggleAttribute(Attribute.background);
                                });
                          },
                          child: Visibility(
                            visible: widget.controller
                                .selectionBackgroundColor() == null,
                            child: Icon(
                              Icons.square,
                              color: selectionBackgroundColorToIconColor(),
                            ),
                          )),
                    ))
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                ToggleAttributeButton(
                  activated: widget.controller
                      .getSelectionStyle()
                      .attributes["list"]?.value == Attribute.unchecked.value ||
                      widget.controller
                          .getSelectionStyle()
                          .attributes["list"]?.value == Attribute.checked.value,
                  icon: Icons.checklist,
                  onPressed: () => toggleAttribute(Attribute.unchecked),
                ),
                ToggleAttributeButton(
                  activated: listAttributeApplied(Attribute.ul),
                  icon: Icons.format_list_bulleted,
                  onPressed: () => toggleListAttribute(Attribute.ul),
                ),
                ToggleAttributeButton(
                  activated: listAttributeApplied(Attribute.ol),
                  icon: Icons.format_list_numbered,
                  onPressed: () => toggleListAttribute(Attribute.ol),
                ),
                ToggleAttributeButton(
                  activated: attributeApplied(Attribute.blockQuote),
                  icon: Icons.format_quote,
                  onPressed: () => toggleAttribute(Attribute.blockQuote),
                ),
                ToggleAttributeButton(
                  activated: attributeApplied(Attribute.codeBlock),
                  icon: Icons.code,
                  onPressed: () => toggleAttribute(Attribute.codeBlock),
                ),
                ToggleAttributeButton(
                  activated: attributeApplied(Attribute.lineHeight),
                  icon: Icons.height,
                  onPressed: () {
                    setState(() {
                      final lineHeight = widget.controller
                          .getSelectionStyle()
                          .attributes[Attribute.lineHeight.key]?.value;
                      if (lineHeight != null) {
                        if (lineHeight ==
                            LineHeightAttribute.lineHeightTight.value) {
                          widget.controller.formatSelection(
                              LineHeightAttribute.lineHeightOneAndHalf);
                        } else if (lineHeight == LineHeightAttribute
                            .lineHeightOneAndHalf.value) {
                          widget.controller.formatSelection(
                              LineHeightAttribute.lineHeightDouble);
                        } else {
                          widget.controller.formatSelection(Attribute.clone(
                              LineHeightAttribute.lineHeightNormal, null));
                        }
                      } else {
                        widget.controller.formatSelection(
                            LineHeightAttribute.lineHeightTight);
                      }
                    });
                  },
                ),
              ])),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              ToggleAttributeButton(
                activated: false,
                icon: Icons.format_indent_decrease,
                onPressed: () {
                  setState(() {
                    widget.controller.skipRequestKeyboard =
                        IndentAttribute().isInline;
                    int? value = widget.controller
                        .getSelectionStyle()
                        .attributes["indent"]?.value;
                    if (value != null) {
                      value--;
                      if (value == 0) {
                        widget.controller.formatSelection(
                            Attribute.clone(IndentAttribute(), null));
                      }
                      else {
                        widget.controller.formatSelection(
                            IndentAttribute(level: value));
                      }
                    }
                  });
                },
              ),
              ToggleAttributeButton(
                activated: false,
                icon: Icons.format_indent_increase,
                onPressed: () {
                  setState(() {
                    widget.controller.skipRequestKeyboard =
                        IndentAttribute().isInline;
                    int? value = widget.controller
                        .getSelectionStyle()
                        .attributes["indent"]?.value;
                    if (value != null) {
                      value++;
                      widget.controller.formatSelection(IndentAttribute(
                          level: value));
                    }
                    else {
                      widget.controller.formatSelection(IndentAttribute(
                          level: 1));
                    }
                  });
                },
              ),
              ToggleAttributeButton(
                activated: !attributeApplied(AlignAttribute(null)),
                icon: Icons.format_align_left,
                onPressed: () => toggleAlignAttribute(AlignAttribute(null)),
              ),
              ToggleAttributeButton(
                activated: alignAttributeApplied(Attribute.centerAlignment),
                icon: Icons.format_align_center,
                onPressed: () =>
                    toggleAlignAttribute(Attribute.centerAlignment),
              ),
              ToggleAttributeButton(
                activated: alignAttributeApplied(Attribute.rightAlignment),
                icon: Icons.format_align_right,
                onPressed: () => toggleAlignAttribute(Attribute.rightAlignment),
              ),
              ToggleAttributeButton(
                activated: alignAttributeApplied(Attribute.justifyAlignment),
                icon: Icons.format_align_justify,
                onPressed: () =>
                    toggleAlignAttribute(Attribute.justifyAlignment),
              ),
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              EditNoteTextSize(
                  value: double.tryParse(widget.controller
                      .getSelectionStyle()
                      .attributes[Attribute.size.key]?.value ?? "") ??
                      note.textSize ??
                      15,
                  controller: widget.controller,
                  onChange: (size) {
                    setState(() {
                      widget.controller.skipRequestKeyboard =
                          Attribute.size.isInline;
                      if (size == note.textSize) {
                        widget.controller.formatSelection(
                            Attribute.clone(Attribute.size, null));
                      } else {
                        widget.controller.formatSelection(
                            SizeAttribute(size.toString()));
                      }
                    });
                  }),
              EditNoteFont(
                  noteEditingController: widget.controller,
                  onChange: (font) {
                    widget.controller.skipRequestKeyboard =
                        Attribute.font.isInline;
                    if (font == "") {
                      widget.controller.formatSelection(
                          Attribute.clone(Attribute.font, null));
                    } else {
                      widget.controller.formatSelection(FontAttribute(font));
                    }
                  })
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cityvisit/apis/project_information/project_api.dart';
import 'package:cityvisit/core/constants/constants.dart';
import 'package:cityvisit/core/extension/extensions.dart';
import 'package:cityvisit/core/utils/user_data.dart';
import 'package:cityvisit/core/utils/utils.dart';
import 'package:cityvisit/modals/request/site_details/add_site_request.dart';
import 'package:cityvisit/routes/routes.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter/flutter_painter.dart';
import 'package:flutter_painter/flutter_painter_pure.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PhotoController extends GetxController {
  List<String> bottomIcon = <String>[
    AppAssets.pen,
    AppAssets.gallery,
    AppAssets.text,
    AppAssets.eraser,
  ];
  Map<String, dynamic> allData = {};
  final ProjectApi _projectApi = ProjectApi.instance;
  String? image;
  String? floorName;
  RxList<TagModal> positionList = <TagModal>[].obs;
  ui.Image? backgroundImage;
  RxInt selectedIconIndex = 2.obs;
  PainterController controller = PainterController(
    settings: PainterSettings(
      freeStyle: const FreeStyleSettings(
        color: Colors.red,
        strokeWidth: 5,
      ),
      shape: ShapeSettings(
        paint: Paint()
          ..strokeWidth = 5
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      ),
      scale: const ScaleSettings(
        enabled: true,
        minScale: 1,
        maxScale: 5,
      ),
    ),
  );
  RxList<String> promptList = <String>[].obs;
  RxInt currentTapIndex = (-1).obs;

  @override
  void onInit() {
    image = Get.arguments['image'];
    floorName = Get.arguments['floor_name'];
    initBackground();
    super.onInit();
  }

  Future<void> continueOnTap(BuildContext context) async {
    String imgUrl = await uploadImage(context);
    List<Coordinate> coordinate = [];
    for (var value in positionList) {
      coordinate.add(
        Coordinate(
          msg: value.textEditingController?.text ?? '',
          x: (value.offset?.dx ?? 0).toString(),
          y: (value.offset?.dy ?? 0).toString(),
        ),
      );
      log(value.textEditingController?.text ?? '',
          name: "textEditingController");
    }
    UserData().imageData = ImageData(img: imgUrl, coordinate: coordinate);

    Get.until((route) => route.settings.name == Routes.createNewSite);
  }

  void initBackground() async {
    // Extension getter (.image) to get [ui.Image] from [ImageProvider]
    print("Current url ==> $image");

    final imageUrl = await FileImage(File(image!)).image;

    backgroundImage = imageUrl;
    controller.background = imageUrl.backgroundDrawable;
    print("Current url ==> $imageUrl");
  }

  void toggleFreeStyleErase() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.erase
        ? FreeStyleMode.erase
        : FreeStyleMode.none;
  }

  void toggleFreeStyleDraw() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.draw
        ? FreeStyleMode.draw
        : FreeStyleMode.none;
  }

  void setFreeStyleStrokeWidth(double value) {
    controller.freeStyleStrokeWidth = value;
  }

  void onChanged(String value) {
    promptList.clear();
    if (value.trim().isEmpty) {
      return;
    }
    for (var element in promptText) {
      if (element.toLowerCase().contains(value.toLowerCase())) {
        promptList.add(element);
      }
    }
  }

  void setFreeStyleColor(double hue) {
    controller.freeStyleColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  }

  Future<void> renderAndDisplayImage(BuildContext context) async {
    if (backgroundImage == null) return;
    Loader.show(context);
    final backgroundImageSize = Size(
        backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());

    ui.Image uiImage = await controller.renderImage(backgroundImageSize);

    Uint8List? imageUrl = await uiImage.pngBytes;
    Directory tempDir = await getTemporaryDirectory();
    File fileImage = await File("${tempDir.path}/image.png").create();
    fileImage.writeAsBytesSync(imageUrl!);

    image = fileImage.path;
    await continueOnTap(context);
  }

  Future<String> uploadImage(BuildContext context) async {
    String imageUrl = '';
    var result = await _projectApi.uploadImage(File(image ?? ''));
    result.when(
      (response) {
        Loader.dismiss(context);
        log(response, name: "response");
        imageUrl = response;
      },
      (error) {
        Loader.dismiss(context);
        log("response ==> $error");
        Get.context!.showSnackBar(error);
        imageUrl = '';
      },
    );
    log("return", name: "return");
    log(imageUrl, name: "imageUrl");

    return imageUrl;
  }

  Future<void> bottomIconOnTap(int index) async {
    selectedIconIndex.value = index;
    if (index == 0) {
      toggleFreeStyleDraw();
    }
    if (index == 1) {
      controller.freeStyleMode = FreeStyleMode.none;
      bool status = await CheckPermissionStatus.checkGalleryPermissionStatus();
      if (status) {
        File? file = await CheckPermissionStatus.pickImage(ImageSource.gallery);
        if (file != null) {
          log(file.path, name: "Image Path");
          controller.addImage(
            await FileImage(file).image,
            const Size(100, 100),
          );
        }
      }
    }
    if (index == 2) {
      controller.freeStyleMode = FreeStyleMode.none;
    }
    if (index == 3) {
      toggleFreeStyleErase();
    }
  }
}

class TagModal {
  Offset? offset;
  TextEditingController? textEditingController = TextEditingController();

  TagModal({this.offset, this.textEditingController});
}

class RenderedImageDialog extends StatelessWidget {
  final Future<File> imageFuture;

  const RenderedImageDialog({Key? key, required this.imageFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rendered Image"),
      content: FutureBuilder<File>(
        future: imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }
          return InteractiveViewer(
              maxScale: 10, child: Image.file(snapshot.data!));
        },
      ),
    );
  }
}

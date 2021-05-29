import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';

class ImageCapture extends StatefulWidget {
  final Function(File file) onChange;

  ImageCapture({required this.onChange});

  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File? _imageFile;

  Future<void> _cropImage() async {
    if (_imageFile == null) {
      return;
    }

    File? cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile!.path,
      aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });

    widget.onChange(_imageFile!);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final PickedFile? pickedFile = await picker.getImage(source: source);
    if (pickedFile == null) {
      return;
    }
    File formattedPickedFile = File(pickedFile.path);

    setState(() {
      _imageFile = formattedPickedFile;
    });

    _cropImage();
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          if (_imageFile == null) ...[
            Container(
              height: 88,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/images/paw.svg',
                    color: Theme.of(context).accentColor,
                    width: 72,
                    height: 72,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(L10n.of(context).select_avatar),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.photo_camera),
                            onPressed: () => _pickImage(ImageSource.camera),
                          ),
                          IconButton(
                            icon: Icon(Icons.photo_library),
                            onPressed: () => _pickImage(ImageSource.gallery),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          if (_imageFile != null) ...[
            Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Image.file(_imageFile!),
                ),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          L10n.of(context).delete_avatar,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(width: ThemeConstants.spacing(0.5)),
                        Icon(
                          Icons.delete,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ],
                    ),
                    onPressed: _clear,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

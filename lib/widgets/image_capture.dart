import 'dart:io' show Platform;
import 'dart:io' show File;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';
import 'package:pdoc/extensions/string.dart';

class ImageCapture extends StatefulWidget {
  final Function(File? file) onChange;
  final String noImageSvgAsset;
  final String? initialImage;

  ImageCapture({
    required this.onChange,
    required this.noImageSvgAsset,
    this.initialImage,
  });

  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _setInitialImageFile();
  }

  Future<void> _setInitialImageFile() async {
    if (widget.initialImage == null) {
      return;
    }
    File formattedPickedFile = await widget.initialImage!.getFileFromCachedImage();
    setState(() {
      _imageFile = formattedPickedFile;
    });
  }

  Future<void> _cropImage() async {
    if (_imageFile == null) {
      return;
    }

    File? cropped = await ImageCropper.cropImage(
      iosUiSettings: IOSUiSettings(
        rotateButtonsHidden: true,
        rotateClockwiseButtonHidden: true,
      ),
      androidUiSettings: AndroidUiSettings(
        lockAspectRatio: true,
        hideBottomControls: true,
      ),
      sourcePath: _imageFile!.path,
      aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2.5),
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });

    widget.onChange(_imageFile);
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

    widget.onChange(_imageFile);

    _cropImage();
  }

  void _clear() {
    setState(() => _imageFile = null);
    widget.onChange(_imageFile);
  }

  void _showBottomSheet() {
    if (Platform.isIOS) {
      _showCupertinoBottomSheet();
      return;
    }
    _showMaterialBottomSheet();
  }

  void _showMaterialBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(ThemeConstants.spacing(1)),
          height: 155,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L10n.of(context).select_avatar,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: ThemeConstants.spacing(0.5)),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt),
                    SizedBox(width: ThemeConstants.spacing(2)),
                    Text(L10n.of(context).camera),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(Icons.photo_library),
                    SizedBox(width: ThemeConstants.spacing(2)),
                    Text(L10n.of(context).library),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCupertinoBottomSheet() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(L10n.of(context).select_avatar),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: Text(L10n.of(context).camera),
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(L10n.of(context).library),
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          )
        ],
        cancelButton: CupertinoButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            L10n.of(context).cancel_text,
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          if (_imageFile == null) ...[
            Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SvgPicture.asset(
                    widget.noImageSvgAsset,
                    color: Theme.of(context).accentColor,
                    height: 166,
                    width: 166,
                  ),
                ),
                SizedBox(height: ThemeConstants.spacing(1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: _showBottomSheet,
                    ),
                  ],
                ),
              ],
            ),
          ],
          if (_imageFile != null) ...[
            Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    _imageFile!,
                    width: 200,
                    height: 166,
                  ),
                ),
                SizedBox(height: ThemeConstants.spacing(1)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: _clear,
                    ),
                    SizedBox(width: ThemeConstants.spacing(1.5)),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: _showBottomSheet,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

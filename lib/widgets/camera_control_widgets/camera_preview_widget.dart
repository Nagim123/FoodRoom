import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:food_ai/containers/resources.dart';

class CameraPreviewWidgetController {
  late VoidCallback _takePhoto;
  late CameraController realController;

  void takePhoto() {
    _takePhoto.call();
  }
}

class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget(
      {super.key, required this.controller, required this.onPhotoReady});

  final CameraPreviewWidgetController controller;
  final Function(XFile) onPhotoReady;

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidget();
}

class _CameraPreviewWidget extends State<CameraPreviewWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // Get a specific camera from the list of available cameras.
    final firstCamera = resources.camera;
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        firstCamera,
        // Define the resolution to use.
        ResolutionPreset.max,
        enableAudio: false);

    widget.controller.realController = _controller;
    widget.controller._takePhoto = () async {
      // Take the Picture in a try / catch block. If anything goes wrong,
      // catch the error.
      try {
        // Ensure that the camera is initialized.
        await _initializeControllerFuture;

        // Attempt to take a picture and then get the location
        // where the image file is saved.
        final image = await _controller.takePicture();
        widget.onPhotoReady(image);
      } catch (e) {
        // If an error occurs, log the error to the console.
        print(e);
      }
    };
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          final mediaSize = MediaQuery.of(context).size;
          final scale =
              1 / (_controller.value.aspectRatio * mediaSize.aspectRatio);
          return ClipRect(
            clipper: _MediaSizeClipper(mediaSize),
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topCenter,
              child: CameraPreview(_controller),
            ),
          );
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;
  const _MediaSizeClipper(this.mediaSize);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

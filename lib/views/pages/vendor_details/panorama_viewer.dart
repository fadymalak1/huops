import 'package:flutter/material.dart';
import 'package:huops/models/vendor_images.dart';
import 'package:panorama_viewer/panorama_viewer.dart';

class Panorama360 extends StatelessWidget {
  const Panorama360({super.key,required this.panorama});
  final Panorama panorama;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PanoramaViewer(
          child: Image.network("${panorama.panorama}"),
        ),
      ),
    );
  }
}

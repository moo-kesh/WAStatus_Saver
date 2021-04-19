import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_status/controller/file_manager.dart';
import 'package:whatsapp_status/models/status_model.dart';
import 'package:whatsapp_status/styles/themes.dart';

// ignore: must_be_immutable
class MediaPlayer extends StatefulWidget {
  MediaPlayer(this.data);
  StatusModel data;

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<MediaPlayer> {
  /*VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
        });
      });
  }

  void onPressedMethod() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }
*/
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;

  Future<void> initializePlayer() async {
    _videoPlayerController1 =
        VideoPlayerController.file(File(widget.data.path));
    await Future.wait([
      _videoPlayerController1.initialize(),
    ]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.green,
        handleColor: Colors.greenAccent,
        backgroundColor: Colors.black54,
        bufferedColor: Colors.lightGreen,
      ),
      showControlsOnInitialize: true,
      placeholder: Container(
        color: Colors.black54,
      ),
      autoInitialize: true,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.data.fileType == StatusModel.VIDEO) {
      initializePlayer();
    }
  }

  @override
  void dispose() {
    if (_videoPlayerController1 != null) {
      _videoPlayerController1.dispose();
      _chewieController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data.isFileSaved);
    return MaterialApp(
      theme: Themes.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 35),
          child: widget.data.isFileSaved
              ? FloatingActionButton(
                  onPressed: () {
                    Provider.of<FilesManager>(context, listen: false)
                        .deleteStatus(widget.data);
                  },
                  child: Icon(Icons.delete_forever_rounded),
                )
              : FloatingActionButton(
                  onPressed: () {
                    Provider.of<FilesManager>(context, listen: false)
                        .saveStatus(widget.data);
                  },
                  child: Icon(Icons.download_rounded),
                ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white70.withOpacity(0.5),
          leading: GestureDetector(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: Text(widget.data.fileType == StatusModel.IMAGE
              ? 'Image Viewer'
              : 'Video Player'),
        ),
        body: Center(
          child: widget.data.fileType == StatusModel.IMAGE
              ? imageViewer(widget.data.path)
              : videoPlayer(context, widget.data.path),
        ),
      ),
    );
  }

  Widget imageViewer(String path) {
    return Container(
      child: Hero(
          tag: path,
          child: PhotoView(
            imageProvider: FileImage(File(path)),
          )),
    );
  }

  Widget videoPlayer(BuildContext context, String path) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: _chewieController != null &&
                    _chewieController.videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: _chewieController,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Loading'),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

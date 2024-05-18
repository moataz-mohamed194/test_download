import 'dart:io';

// import 'package:android_path_provider/android_path_provider.dart';
import 'package:download_assets/download_assets.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
//
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Download Assets Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Download Assets'),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DownloadAssetsController downloadAssetsController =
      DownloadAssetsController();
  DownloadAssetsController downloadAssetsController0 =
      DownloadAssetsController();
  String message = 'Press the download button to start the download';
  bool downloaded = false;
  double value = 0.0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    await downloadAssetsController.init(assetDir: 'math');
    downloaded = await downloadAssetsController.assetsDirAlreadyExists();
    print('${downloadAssetsController.assetsDir}/assessment_part.png');
    print(
        "$downloaded , ${downloadAssetsController.assetsDir}, ${await downloadAssetsController.assetsDirAlreadyExists()}");
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (downloaded) ...[
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(
                          '${downloadAssetsController.assetsDir}/assessment_part.png')),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(
                          '${downloadAssetsController.assetsDir}/assessment_part.png')),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ],
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                tween: Tween<double>(
                  begin: 0,
                  end: value,
                ),
                builder: (context, value, _) => LinearProgressIndicator(
                  minHeight: 10,
                  value: value,
                ),
              ),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _downloadAssets,
              tooltip: 'Download',
              child: Icon(Icons.arrow_downward),
            ),
            const SizedBox(
              width: 25,
            ),
            FloatingActionButton(
              onPressed: () async {
                await downloadAssetsController.clearAssets();
                await _downloadAssets();
              },
              tooltip: 'Refresh',
              child: Icon(Icons.refresh),
            ),
            const SizedBox(
              width: 25,
            ),
            FloatingActionButton(
              onPressed: _cancel,
              tooltip: 'Cancel',
              child: Icon(Icons.cancel_outlined),
            ),
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );

  Future _downloadAssets() async {
    final assetsDownloaded =
        await downloadAssetsController.assetsFileExists('math');
    print('assetsDownloaded:$assetsDownloaded');
    if (assetsDownloaded) {
      setState(() {
        message = 'Click in refresh button to force download';
        print(message);
      });
      return;
    }

    try {
      value = 0.0;
      downloaded = false;
      await downloadAssetsController.init(assetDir: 'math');

      await downloadAssetsController.startDownload(
          onCancel: () {
            message = 'Cancelled by user';
            setState(() {});
          },
          assetsUrls: [
            // 'https://github.com/edjostenes/download_assets/raw/main/download/assets.zip',
            'https://ambernoak.co.uk/Fillament/public/storage/math.rar'
          ],
          onProgress: (progressValue) {
            value = progressValue;
            setState(() {
              message =
                  'Downloading - ${(progressValue * 100).toStringAsFixed(2)}';
              print(message);
            });
          },
          onDone: () {
            setState(() {
              downloaded = true;
              message =
                  'Download completed\nClick in refresh button to force download';
            });
          });
    } on DownloadAssetsException catch (e) {
      print(e.toString());
      setState(() {
        downloaded = false;
        message = 'Error: ${e.toString()}';
      });
    }
    print('${downloadAssetsController.assetsDir}');
    print('${downloadAssetsController.assetsDir?.length}');
    String rar5_path = '${downloadAssetsController.assetsDir}/math.rar';
    // print(
    //     "${await CounterStorage().listFilesAndFolders(downloadAssetsController.assetsDir ?? '')}");
    //
    // final directory = downloadAssetsController.assetsDir;
    // final rarFilePath = '${directory}/math.rar';
    // final destinationDirPath = '${directory}';
    // await CounterStorageZip().requestDownload(
    //     'https://ambernoak.co.uk/Fillament/public/storage/math.rar');
    // }
  }

  void _cancel() => downloadAssetsController.cancelDownload();
}

// class CounterStorage {
//   Future<List<String>> listFilesAndFolders(String path) async {
//     final directory = Directory(path);
//     if (await directory.exists()) {
//       final filesAndFolders = directory.listSync();
//       return filesAndFolders.map((e) => e.path).toList();
//     } else {
//       return [];
//     }
//   }
// }
//
// class CounterStorageZip {
//   String? _localPath;
//
//   Future<String?> _getSavedDir() async {
//     String? externalStorageDirPath;
//
//     if (Platform.isAndroid) {
//       try {
//         externalStorageDirPath = await AndroidPathProvider.downloadsPath;
//       } catch (err, st) {
//         print('failed to get downloads path: $err, $st');
//
//         final directory = await getExternalStorageDirectory();
//         externalStorageDirPath = directory?.path;
//       }
//     } else if (Platform.isIOS) {
//       // var dir = (await _dirsOnIOS)[0]; // temporary
//       // var dir = (await _dirsOnIOS)[1]; // applicationSupport
//       // var dir = (await _dirsOnIOS)[2]; // library
//       var dir = (await _dirsOnIOS)[3]; // applicationDocuments
//       // var dir = (await _dirsOnIOS)[4]; // downloads
//
//       dir ??= await getApplicationDocumentsDirectory();
//       externalStorageDirPath = dir.absolute.path;
//     }
//
//     return externalStorageDirPath;
//   }
//
//   Future<List<Directory?>> get _dirsOnIOS async {
//     final temporary = await getTemporaryDirectory();
//     final applicationSupport = await getApplicationSupportDirectory();
//     final library = await getLibraryDirectory();
//     final applicationDocuments = await getApplicationDocumentsDirectory();
//     final downloads = await getDownloadsDirectory();
//
//     final dirs = [
//       temporary,
//       applicationSupport,
//       library,
//       applicationDocuments,
//       downloads
//     ];
//
//     return dirs;
//   }
//
//   Future<void> _prepareSaveDir() async {
//     _localPath = (await _getSavedDir())!;
//     final savedDir = Directory(_localPath!);
//     if (!savedDir.existsSync()) {
//       await savedDir.create();
//     }
//   }
//
//   Future<void> requestDownload(String url) async {
//     try {
//       await _prepareSaveDir();
//       await Permission.storage.request();
//       print('_localPath:$_localPath');
//       final taskId = await FlutterDownloader.enqueue(
//         url: url,
//         savedDir: _localPath!,
//         saveInPublicStorage: false,
//       );
//     } catch (e, s) {
//       print(e);
//       print(s);
//     }
//   }
// }

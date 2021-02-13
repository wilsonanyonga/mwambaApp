// import 'dart:js';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:furniture_app/constants.dart';
import 'package:furniture_app/models/DownModel.dart';
import 'package:furniture_app/models/HomeModel.dart';
import 'package:furniture_app/models/SafPostModel.dart';
import 'package:furniture_app/models/SafVerifyModel.dart';
import 'package:furniture_app/models/VerifyModel.dart';
import 'package:open_file/open_file.dart';
// import 'package:furniture_app/models/product.dart';

// import 'chat_and_add_to_cart.dart';
// import 'list_of_colors.dart';
import 'product_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ext_storage/ext_storage.dart';

import 'package:provider/provider.dart';


/// Simplest possible model, with just one field.
///
/// [ChangeNotifier] is a class in `flutter:foundation`. [Counter] does
/// _not_ depend on Provider.
class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }
}

class DownFile with ChangeNotifier {
  bool value;

  // free download
  bool isDownloaded;
  String progress;
  String directory;

  // 500 download
  bool isDownloadedFloorPlan;
  String progressFloorPlan;
  String directoryFloorPlan;
  bool buttonPlanDownload;
  bool buttonStateFloorPlan;

  // -------------------------------------------------
  // ---------------free download-------------
  void setDownload(value) {
    isDownloaded = value;
    notifyListeners();
  }
  bool getSetDownload(){
    return isDownloaded;
  }

  void setDirectory(value) {
    directory = value;
    notifyListeners();
  }
  String getSetDirectory(){
    return directory;
  }

  void setProgress(value){
    progress = value;
    notifyListeners();
  }
  String getSetProgress(){
    return progress;
  }

  // -------------------------------------------------
  // ---------------500 download-------------
  void setDownloadFloorPlan(value) {
    isDownloadedFloorPlan = value;
    notifyListeners();
  }
  bool getSetDownloadFloorPlan(){
    return isDownloadedFloorPlan;
  }

  void setDirectoryFloorPlan(value) {
    directoryFloorPlan = value;
    notifyListeners();
  }
  String getSetDirectoryFloorPlan(){
    return directoryFloorPlan;
  }

  void setProgressFloorPlan(value){
    progressFloorPlan = value;
    notifyListeners();
  }
  String getSetProgressFloorPlan(){
    return progressFloorPlan;
  }

  void setbuttonPlanDownload(value){
    buttonPlanDownload = value;
    notifyListeners();
  }
  bool getbuttonPlanDownload(){
    return buttonPlanDownload;
  }

  void setbuttonStateFloorPlan(value){
    buttonStateFloorPlan = value;
    notifyListeners();
  }
  bool getbuttonStateFloorPlan(){
    return buttonStateFloorPlan;
  }
}

class Body extends StatefulWidget {
  
  final Result product;

  const Body({Key key, this.product}) : super(key: key);
  
  @override
  _BodyState createState() => _BodyState();

  
}

class _BodyState extends State<Body> {

  // final PutModel responseDown;
  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String checkoutRequestId;
  
  bool downloading;
  bool downloadingFloorPlan;
  bool downloadingBasic;
  bool downloadingPremium;

  String progress;
  String progressFloorPlan;
  String progressBasic;
  String progressPremium;

  String directory;
  String directoryFloorPlan;
  String directoryBasic;
  String directoryPremium;

  String downData; // for checking contents of download url

  bool isDownloaded;
  bool isDownloadedFloorPlan;
  bool isDownloadedBasic;
  bool isDownloadedPremium;

  String uri; // url of the file to be downloaded
  String uriFloorPlan; // url of the file to be downloaded
  String uriBasic; // url of the file to be downloaded
  String uriPremium; // url of the file to be downloaded

  String filename; // file name that you desire to keep
  String filenameFloorPlan;
  String filenameBasic;
  String filenamePremium;

  TextEditingController _controllerPhone = TextEditingController();
  TextEditingController _controllerPhoneBasic = TextEditingController();
  TextEditingController _controllerPhonePremium = TextEditingController();

  Dio dio = Dio();

  bool buttonStateFloorPlan;
  bool buttonStateBasic;
  bool buttonStatePremium;

  bool buttonPlanDownload;
  bool buttonBasicDownload;
  bool buttonPremiumDownload;

  bool buttonPlanVerifyDownload;
  bool buttonBasicVerifyDownload;
  bool buttonPremiumVerifyDownload;

  

  Map<String, dynamic> result;
  Map<String, dynamic> resultFloorPlan;
  Map<String, dynamic> resultBasic;
  Map<String, dynamic> resultPremium;
  // @override
  // setState(() {
  //                 buttonStateFloorPlan = true;
  //               });
  @override
  initState() {
    // used for notification
    result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };
    resultFloorPlan = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };
    resultBasic = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };
    resultPremium = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    buttonStateFloorPlan = true;
    Provider.of<DownFile>(context, listen: false).setbuttonStateFloorPlan(true);
    buttonStateBasic = true;
    buttonStatePremium = true;

    buttonPlanDownload = true;
    Provider.of<DownFile>(context, listen: false).setbuttonPlanDownload(true);
    buttonBasicDownload = true;
    buttonPremiumDownload = true;

    buttonPlanVerifyDownload = true;
    buttonBasicVerifyDownload = true;
    buttonPremiumVerifyDownload = true;

    downloading = false;
    downloadingFloorPlan = false;
    downloadingBasic = false;
    downloadingPremium = false;

    progress = '-';
    Provider.of<DownFile>(context, listen: false).setProgress('-');
    progressFloorPlan = '-';
    Provider.of<DownFile>(context, listen: false).setProgressFloorPlan('-');
    progressBasic = '-';
    progressPremium = '-';

    isDownloaded = false;
    Provider.of<DownFile>(context, listen: false).setDownload(false);
    isDownloadedFloorPlan = false;
    Provider.of<DownFile>(context, listen: false).setDownloadFloorPlan(false);
    isDownloadedBasic = false;
    isDownloadedPremium = false;

    uri = 'http://mwambabuilders.com/mwambaApp/api/uploads/${widget.product.sample}'; // url of the file to be downloaded
    uriFloorPlan = 'http://mwambabuilders.com/mwambaApp/api/uploads/${widget.product.plan}';
    uriBasic = 'http://mwambabuilders.com/mwambaApp/api/uploads/${widget.product.basic}';
    uriPremium = 'http://mwambabuilders.com/mwambaApp/api/uploads/${widget.product.premium}';

    filename = widget.product.sample; // file name that you desire to keep
    filenameFloorPlan = widget.product.plan;
    filenameBasic = widget.product.basic;
    filenamePremium = widget.product.premium;

    // notification code using notification plugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: _onSelectNotification);

    super.initState();
  //   setstate(){
    
  // }
  }
  void _buttonTrue() {
    setState(() {
      buttonStateFloorPlan = true;
    });
  }

  void _buttonFalse() {
    setState(() {
      buttonStateFloorPlan = false;
    });
    // StatefulBuilder(
    //   builder: (BuildContext context, StateSetter setState){
        
    //   });
    
  }

  // this function is used in the notification
  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      priority: Priority.High,
      importance: Importance.Max
    );
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android, iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
      0, // notification id
      isSuccess ? 'Success' : 'Failure',
      isSuccess ? 'File has been downloaded successfully!' : 'There was an error while downloading the file.',
      platform,
      payload: json
    );
  }

  // notification future
  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
      setState(() {
        // used for notification
        result = {
          'isSuccess': false,
          'filePath': null,
          'error': null,
        };
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  // downloading logic is handled by this method
  Future<void> downloadFile(uri, fileName, result) async {
    setState(() {
      isDownloaded = true;
    });
    Provider.of<DownFile>(context, listen: false).setDownload(true);

    String savePath = await getFilePath(fileName);

    // Dio dio = Dio();
    print('object is through');
    // response = await dio.download("https://www.google.com/", "./xx.html");

    

    try {
      Response response = await dio.download(
        uri,
        savePath,
        onReceiveProgress: (rcv, total) {
          print(total);
          print('received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
          print('object prog');
          setState(() {
            progress = ((rcv / total) * 100).toStringAsFixed(0);
            print('progress');
          });
          Provider.of<DownFile>(context, listen: false).setProgress(((rcv / total) * 100).toStringAsFixed(0));

          if (progress == '100') {
            setState(() {
              isDownloaded = true;
              directory = savePath;
              // progress = '100';
            });
          } else if (double.parse(progress) < 100) {}

          if (Provider.of<DownFile>(context, listen: false).getSetProgress() == '100') {
            setState(() {
              isDownloaded = true;
              directory = savePath;
              // progress = '100';
            });
            Provider.of<DownFile>(context, listen: false).setDownload(true);
            Provider.of<DownFile>(context, listen: false).setDirectory(savePath);
            
          } else if (double.parse(Provider.of<DownFile>(context, listen: false).getSetProgress()) < 100) {}
        },
        deleteOnError: true,
      );
      // handling the notification
      // try {
      //   PutModel res = PutModel.fromJson(response.data);
      //   print(res.code);
      // } catch (e) {
        
      // }
      
      result['isSuccess'] = response.statusCode == 200;
      // result['filePath'] = '${dir.first.path}';
      result['filePath'] = savePath;
      // StorageDirectory type = StorageDirectory.downloads;
      // List<Directory> dir = await getExternalStorageDirectories(type: type);
      // // var dir = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);

      
      

      // var so = PutModel.fromJson(jsonDecode(response.data));
      // var some = response;
      // print(response.data);
    } on DioError catch(e) {
        print('object that i dont know');
        setState(() {
          isDownloaded = false;
          directory = savePath;
          progress = "-";
          // progress = '100';
        });
        Provider.of<DownFile>(context, listen: false).setProgress("-");
        Provider.of<DownFile>(context, listen: false).setDownload(false);
        Provider.of<DownFile>(context, listen: false).setDirectory(savePath);
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        if(e.response != null) {
            print(e.response.data);
            print(e.response.headers);
            print(e.response.request);
        } else{
            // Something happened in setting up or sending the request that triggered an Error
            print(e.request);
            print(e.message);
        }
    } finally {
      // await _showNotification(result);
    }
    
    
  }

  // downloading logic for floorPlan is handled by this method
  Future<void> downloadFileFloorPlan(uriFloorPlan, filenameFloorPlan, resultFloorPlan) async {
    setState(() {
      isDownloadedFloorPlan = true;
    });
    Provider.of<DownFile>(context, listen: false).setDownloadFloorPlan(true);

    String savePath = await getFilePathFloorPlan(filenameFloorPlan);

    // Dio dio = Dio();
    print('object is through');
    // response = await dio.download("https://www.google.com/", "./xx.html");

    

    try {
      Response response = await dio.download(
        uriFloorPlan,
        savePath,
        onReceiveProgress: (rcv, total) {
          print(total);
          print('received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
          print('object prog');
          setState(() {
            progressFloorPlan = ((rcv / total) * 100).toStringAsFixed(0);
            print('progress');
          });
          Provider.of<DownFile>(context, listen: false).setProgressFloorPlan(((rcv / total) * 100).toStringAsFixed(0));
          if (progressFloorPlan == '100') {
            setState(() {
              isDownloadedFloorPlan = true;
              directoryFloorPlan = savePath;
              // progress = '100';
            });
          } else if (double.parse(progressFloorPlan) < 100) {}

          if (Provider.of<DownFile>(context, listen: false).getSetProgressFloorPlan() == '100') {
            setState(() {
              isDownloadedFloorPlan = true;
              directoryFloorPlan = savePath;
              // progress = '100';
            });
            Provider.of<DownFile>(context, listen: false).setDownloadFloorPlan(true);
            Provider.of<DownFile>(context, listen: false).setDirectoryFloorPlan(savePath);
          } else if (double.parse(Provider.of<DownFile>(context, listen: false).getSetProgressFloorPlan()) < 100) {}
        },
        deleteOnError: true,
      );
      // handling the notification
      // try {
      //   PutModel res = PutModel.fromJson(response.data);
      //   print(res.code);
      // } catch (e) {
        
      // }
      
      result['isSuccess'] = response.statusCode == 200;
      // result['filePath'] = '${dir.first.path}';
      result['filePath'] = savePath;
      // StorageDirectory type = StorageDirectory.downloads;
      // List<Directory> dir = await getExternalStorageDirectories(type: type);
      // // var dir = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);

      
      

      // var so = PutModel.fromJson(jsonDecode(response.data));
      // var some = response;
      // print(response.data);
    } on DioError catch(e) {
        print('object that i dont know');
        setState(() {
          isDownloadedFloorPlan = false;
          directoryFloorPlan = savePath;
          progressFloorPlan = "-";
          // progress = '100';
        });
        Provider.of<DownFile>(context, listen: false).setProgressFloorPlan("-");
        Provider.of<DownFile>(context, listen: false).setDownloadFloorPlan(false);
        Provider.of<DownFile>(context, listen: false).setDirectoryFloorPlan(savePath);
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        if(e.response != null) {
            print(e.response.data);
            print(e.response.headers);
            print(e.response.request);
        } else{
            // Something happened in setting up or sending the request that triggered an Error
            print(e.request);
            print(e.message);
        }
    } finally {
      // await _showNotification(result);
    }
    
    
  }

  // downloading logic for floorPlan is handled by this method
  Future<void> downloadFileBasic(uriBasic, filenameBasic, resultBasic) async {
    setState(() {
      isDownloadedBasic = true;
    });

    String savePath = await getFilePath(filenameBasic);

    // Dio dio = Dio();
    print('object is through');
    // response = await dio.download("https://www.google.com/", "./xx.html");

    

    try {
      Response response = await dio.download(
        uriBasic,
        savePath,
        onReceiveProgress: (rcv, total) {
          print(total);
          print('received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
          print('object prog');
          setState(() {
            progressBasic = ((rcv / total) * 100).toStringAsFixed(0);
            print('progress');
          });

          if (progressBasic == '100') {
            setState(() {
              isDownloadedBasic = true;
              directoryBasic = savePath;
              // progress = '100';
            });
          } else if (double.parse(progressBasic) < 100) {}
        },
        deleteOnError: true,
      );
      // handling the notification
      // try {
      //   PutModel res = PutModel.fromJson(response.data);
      //   print(res.code);
      // } catch (e) {
        
      // }
      
      result['isSuccess'] = response.statusCode == 200;
      // result['filePath'] = '${dir.first.path}';
      result['filePath'] = savePath;
      // StorageDirectory type = StorageDirectory.downloads;
      // List<Directory> dir = await getExternalStorageDirectories(type: type);
      // // var dir = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);

      
      

      // var so = PutModel.fromJson(jsonDecode(response.data));
      // var some = response;
      // print(response.data);
    } on DioError catch(e) {
        print('object that i dont know');
        setState(() {
          isDownloadedBasic = false;
          directoryBasic = savePath;
          progressBasic = "-";
          // progress = '100';
        });
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        if(e.response != null) {
            print(e.response.data);
            print(e.response.headers);
            print(e.response.request);
        } else{
            // Something happened in setting up or sending the request that triggered an Error
            print(e.request);
            print(e.message);
        }
    } finally {
      // await _showNotification(result);
    }
    
    
  }

// downloading logic for floorPlan is handled by this method
Future<void> downloadFilePremium(uriPremium, filenamePremium, resultPremium) async {
  setState(() {
    isDownloadedPremium = true;
  });

  String savePath = await getFilePath(filenamePremium);

  // Dio dio = Dio();
  print('object is through');
  // response = await dio.download("https://www.google.com/", "./xx.html");

  

  try {
    Response response = await dio.download(
      uriPremium,
      savePath,
      onReceiveProgress: (rcv, total) {
        print(total);
        print('received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
        print('object prog');
        setState(() {
          progressPremium = ((rcv / total) * 100).toStringAsFixed(0);
          print('progress');
        });

        if (progressPremium == '100') {
          setState(() {
            isDownloadedPremium = true;
            directoryPremium = savePath;
            // progress = '100';
          });
        } else if (double.parse(progressPremium) < 100) {}
      },
      deleteOnError: true,
    );
    // handling the notification
    // try {
    //   PutModel res = PutModel.fromJson(response.data);
    //   print(res.code);
    // } catch (e) {
      
    // }
    
    result['isSuccess'] = response.statusCode == 200;
    // result['filePath'] = '${dir.first.path}';
    result['filePath'] = savePath;
    // StorageDirectory type = StorageDirectory.downloads;
    // List<Directory> dir = await getExternalStorageDirectories(type: type);
    // // var dir = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);

    
    

    // var so = PutModel.fromJson(jsonDecode(response.data));
    // var some = response;
    // print(response.data);
  } on DioError catch(e) {
      print('object that i dont know');
      setState(() {
        isDownloadedPremium = false;
        directoryPremium = savePath;
        progressPremium = "-";
        // progress = '100';
      });
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if(e.response != null) {
          print(e.response.data);
          print(e.response.headers);
          print(e.response.request);
      } else{
          // Something happened in setting up or sending the request that triggered an Error
          print(e.request);
          print(e.message);
      }
  } finally {
    // await _showNotification(result);
  }
  
  
}

  //gets the applicationDirectory and path for the to-be downloaded file

  // which will be used to save the file to that path in the downloadFile method

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    StorageDirectory type = StorageDirectory.downloads;
    List<Directory> dir = await getExternalStorageDirectories(type: type);
    // var dir = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);

    path = '${dir.first.path}/$uniqueFileName';
    // path = '$dir/$uniqueFileName';
    print(path);
    return path;
  }

  //gets the applicationDirectory and path for the to-be downloaded file
  // which will be used to save the file to that path in the downloadFile method

  Future<String> getFilePathFloorPlan(uniqueFileName) async {
    String path = '';

    StorageDirectory type = StorageDirectory.downloads;
    List<Directory> dir = await getExternalStorageDirectories(type: type);
    // var dir = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);

    path = '${dir.first.path}/$uniqueFileName';
    // path = '$dir/$uniqueFileName';
    print(path);
    return path;
  }

  

  // void _getFree(){
  //   HomeReq().homeReq().then((following) {
  //     // final result = json.decode(following.body)['trucks'];
  //     print(following.body);
  //     // // print(result['trucks']);
  //     // Iterable list = result;
  //     Iterable list = jsonDecode(following.body)['result'];
  //     // print(list);
  //     setState(() {
  //       print(list);
  //       // HomeModel users = HomeModel.fromJson(json.decode(following.body));
  //       resultsMod = list.map((model) => Result.fromJson(model)).toList();
  //       // users = list;
  //       print(resultsMod.length);
  //     });
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    // it provide us total height and width
    Size size = MediaQuery.of(context).size;
    // it enable scrolling on small devices
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              decoration: BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Hero(
                      tag: '${widget.product.id}',
                      child: widget.product.uploadName != null ? ProductPoster(
                        size: size,
                        image: widget.product.uploadName,
                      ): Container(child: Align(child: Text('Data is loading ...'))),
                    ),
                  ),
                  // ListOfColors(),
                  freePdf(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding / 2),
                      child: Text(
                        widget.product.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  // Text(
                  //   'Ksh ${product.price}',
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.w600,
                  //     color: kSecondaryColor,
                  //   ),
                  // ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                    child: Text(
                      widget.product.description,
                      style: TextStyle(color: kTextLightColor),
                    ),
                  ),
                  SizedBox(height: kDefaultPadding),
                ],
              ),
            ),
            // ChatAndAddToCart(),
            plan500(),
            buyPlan(),
            buyCad(),
          ],
        ),
      ),
    );

    
  }

  
  

  Widget buyPlan() {
    return buttonBasicDownload ? GestureDetector(
          onTap: _showPlan,
          child: Container(
            margin: EdgeInsets.all(kDefaultPadding),
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 2,
            ),
            decoration: BoxDecoration(
              // color: Color(0xFFFCBF1E),
              color: Colors.pink[300],
              // color: Color.fromRGBO( 199, 0, 57, .2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Column(
                children: [
                  Text('$progressBasic%'),
                  isDownloadedBasic ? Text(
                      'File Downloaded! You can see your file in the application\'s directory \n \n $directoryBasic',
                    ) : Text("Click to Buy Plan (.zip) - Ksh ${widget.product.basicAmount}")
                ],
              ),
            ),
            
          ),
    ) :
    Container(
        margin: EdgeInsets.all(kDefaultPadding),
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: Colors.pink[300],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Column(
            children: [
              Text('$progressBasic%'),
              isDownloadedBasic ? Text(
                      'File Downloaded! You can see your file in the application\'s directory \n \n $directoryBasic',
                    )
              : Text("Click to Download Floor Plan Ksh ${widget.product.basicAmount}"),
            ],
          ),
        ),
        
      );
  }

  Widget buyCad() {
    return buttonPremiumDownload ? GestureDetector(
          onTap: _showCad,
          child: Container(
            margin: EdgeInsets.all(kDefaultPadding),
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 2,
            ),
            decoration: BoxDecoration(
              // color: Color(0xFFFCBF1E),
              color: Colors.green[300],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              
              child: Column(
                children: [
                  Text('$progressPremium%'),
                  isDownloadedPremium ? Text(
                      'File Downloaded! You can see your file in the application\'s directory \n \n $directoryPremium',
                    ) : Text("Click to Buy ArchiCAD (Archi) - Ksh ${widget.product.premiumAmount}")
                ],
              ),
            ),
            
          ),
        ) : 
        Container(
          margin: EdgeInsets.all(kDefaultPadding),
          padding: EdgeInsets.symmetric(
            horizontal: kDefaultPadding,
            vertical: kDefaultPadding / 2,
          ),
          decoration: BoxDecoration(
            color: Colors.green[300],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Column(
              children: [
                Text('$progressPremium%'),
                isDownloadedPremium ? Text(
                        'File Downloaded! You can see your file in the application\'s directory \n \n $directoryPremium',
                      )
                : Text("Click to Download Floor Plan Ksh ${widget.product.premiumAmount}"),
              ],
            ),
          ),
          
        );
  }

  Widget freePdf() {
    // return Container(
    //       margin: EdgeInsets.all(kDefaultPadding),
    //       padding: EdgeInsets.symmetric(
    //         horizontal: kDefaultPadding,
    //         vertical: kDefaultPadding / 2,
    //       ),
    //       decoration: BoxDecoration(
    //         color: Color(0xFFFCBF1E),
    //         borderRadius: BorderRadius.circular(30),
    //       ),
    //       child: Center(
    //         child: Column(
    //           children: [
    //             Text('$progress%'),
    //             Text(Provider.of<DownFile>(context).getSetProgress()),
    //             isDownloaded ? Text(
    //                     'File Downloaded! You can see your file in the application\'s directory \n \n $directory',
    //                   )
    //                 : Text("Click to Download Sample Pictures"),
    //             Provider.of<DownFile>(context).getSetDownload() ? Text(
    //                     '\'s directory \n \n ${Provider.of<DownFile>(context).getSetDirectory()}',
    //                   )
    //                 : Text("Click 2 Pictures"),
    //           ],
    //         ),
    //       ),
          
    //     );
        return GestureDetector(
          
          onTap: Provider.of<DownFile>(context).getSetDownload() ?  null : () async{
            downloadFile(uri, filename, result);
            // _buttonFalse();
          },
          child: Container(
            margin: EdgeInsets.all(kDefaultPadding),
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 2,
            ),
            decoration: BoxDecoration(
              color: Color(0xFFFCBF1E),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Column(
                children: [
                  // Text('$progress%'),
                  Text('${Provider.of<DownFile>(context).getSetProgress()}%'),
                  // isDownloaded ? Text(
                  //         'File Downloaded! You can see your file in the application\'s directory \n \n $directory',
                  //       )
                  //     : Text("Click to Download Sample Pictures"),
                  Provider.of<DownFile>(context).getSetDownload() ? Text(
                          'File Downloaded! You can see your file in the application\'s directory \n \n ${Provider.of<DownFile>(context).getSetDirectory()}',
                        )
                      : Text("Click to Download Sample Pictures"),
                ],
              ),
            ),
            
          ),
        );
   
    // return Container(
    //   child: isDownloaded ? 
    //   Container(
    //       margin: EdgeInsets.all(kDefaultPadding),
    //       padding: EdgeInsets.symmetric(
    //         horizontal: kDefaultPadding,
    //         vertical: kDefaultPadding / 2,
    //       ),
    //       decoration: BoxDecoration(
    //         color: Color(0xFFFCBF1E),
    //         borderRadius: BorderRadius.circular(30),
    //       ),
    //       child: Center(
    //         child: Column(
    //           children: [
    //             Text('$progress%'),
    //             isDownloaded ? Text(
    //                     'File Downloaded! You can see your file in the application\'s directory \n \n $directory',
    //                   )
    //                 : Text("Click to Download Sample Pictures"),
    //           ],
    //         ),
    //       ),
          
    //     )
    //    : GestureDetector(
    //     onTap: () async{
    //       downloadFile(uri, filename, result);
    //       // _buttonFalse();
    //     },
    //     child: Container(
    //       margin: EdgeInsets.all(kDefaultPadding),
    //       padding: EdgeInsets.symmetric(
    //         horizontal: kDefaultPadding,
    //         vertical: kDefaultPadding / 2,
    //       ),
    //       decoration: BoxDecoration(
    //         color: Color(0xFFFCBF1E),
    //         borderRadius: BorderRadius.circular(30),
    //       ),
    //       child: Center(
    //         child: Column(
    //           children: [
    //             Text('$progress%'),
    //             isDownloaded ? Text(
    //                     'File Downloaded! You can see your file in the application\'s directory \n \n $directory',
    //                   )
    //                 : Text("Click to Download Sample Pictures"),
    //           ],
    //         ),
    //       ),
          
    //     ),
    //   ),
    // );
  }

  Widget plan500() {
    return GestureDetector(
      onTap: Provider.of<DownFile>(context).getbuttonPlanDownload() ? _show500 : null,
      child: Container(
        margin: EdgeInsets.all(kDefaultPadding),
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding / 2,
        ),
        decoration: BoxDecoration(
          color: Color(0xFFFCBF1E),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Column(
            children: [
              // Text('$progressFloorPlan%'),
              Text('${Provider.of<DownFile>(context).getSetProgressFloorPlan()}%'),
              // isDownloadedFloorPlan ? Text(
              //         'File Downloaded! You can see your file in the application\'s directory \n \n ${Provider.of<DownFile>(context).getSetDirectoryFloorPlan()}',
              //       )
              // : Text("Click to Download Floor Plan Ksh ${widget.product.planAmount}"),
              Provider.of<DownFile>(context).getSetDownloadFloorPlan() ? Text(
                      'File Downloaded! You can see your file in the application\'s directory \n \n ${Provider.of<DownFile>(context).getSetDirectoryFloorPlan()}',
                    )
              : Text("Click to Download Floor Plan Ksh ${widget.product.planAmount}"),
            ],
          ),
        ),
        
      ),
    ); 
    // :
    
    //   Container(
    //     margin: EdgeInsets.all(kDefaultPadding),
    //     padding: EdgeInsets.symmetric(
    //       horizontal: kDefaultPadding,
    //       vertical: kDefaultPadding / 2,
    //     ),
    //     decoration: BoxDecoration(
    //       color: Color(0xFFFCBF1E),
    //       borderRadius: BorderRadius.circular(30),
    //     ),
    //     child: Center(
    //       child: Column(
    //         children: [
    //           Text('$progressFloorPlan%'),
    //           isDownloadedFloorPlan ? Text(
    //                   'File Downloaded! You can see your file in the application\'s directory \n \n $directoryFloorPlan',
    //                 )
    //           : Text("Click to Download Floor Plan Ksh ${widget.product.planAmount}"),
    //         ],
    //       ),
    //     ),
        
    //   );
  }

  _show500() {
    // StatefulBuilder(
    //   // ignore: missing_return
    //   builder: (BuildContext context, void Function(void Function()) setState) { 
    //     Alert(context: context, title: "RFLUTTER", desc: "Flutter is awesome.").show();
    //    }

    //     // return show;
      
    // );
    // @override
    // Widget build(BuildContext context) {
    //   return Alert(context: context, title: "RFLUTTER", desc: "Flutter is awesome.").show();
    // }
    
    // showDialog(
    //   context: null,
    //   builder: (context) => ,
    // );

    // StatefulBuilder(
    //   builder: (BuildContext context, setState){
    //     return Alert(context: context, title: "RFLUTTER", desc: "Flutter is awesome.").show();
    //   },
    // );
    
    buttonStateFloorPlan ? Alert(
        context: context,
        title: "Floor Plan",
        desc: "Basic Plan. \n\n Enter your Mpesa number below",
        content: Column(
          children: <Widget>[
            
            TextField(
              // obscureText: true,
              // onChanged: (value) {
              //   Provider.of<AddTruckProvider>(context).setMessage2(null);
              // },
              controller: _controllerPhone,
              decoration: InputDecoration(
                icon: Icon(Icons.phone),
                labelText: 'Phone Number (254 712 345 678)',
                // errorText: Provider.of<AddTruckProvider>(context).getMessage2(),
              ),
              inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(12),
                  WhitelistingTextInputFormatter.digitsOnly,
                  
                ],
            ),
            // TextField(
            //   // obscureText: true,
            //   // onChanged: (value) {
            //   //   Provider.of<AddTruckProvider>(context).setMessage3(null);
            //   // },
            //   // controller: _controllerLocation,
            //   decoration: InputDecoration(
            //     icon: Icon(Icons.location_on),
            //     labelText: 'Current Location',
            //   ),
            // ),
          ],
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            // color: Color.fromRGBO(240, 9, 4, 1.0),
            color: Colors.red,
          ),

          DialogButton(
            child: buttonStateFloorPlan ? Text(
              "Test",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ) : Text(
              "No",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async{
              // _buttonFalse();
              setState(() {
                buttonStateFloorPlan = false;
              });
              Navigator.of(context, rootNavigator: true).pop();
              _show500();
            },
            // color: Color.fromRGBO(240, 9, 4, 1.0),
            color: Colors.red,
          ),
          
          DialogButton(
            onPressed: () async{
              // _postTruck();
              // setState(() {
              //   buttonStateFloorPlan = false;
              // });
              // _buttonFalse();
              setState(() {
                buttonStateFloorPlan = false;
              });
              Navigator.of(context, rootNavigator: true).pop();
              _show500();

              print(buttonStateFloorPlan);
              print("button pressed");
              // _success();
              Response responsePhone = await dio.post("http://mwambabuilders.com/mwambaApp/api/sendNumber", data: {"number": _controllerPhone.text});
              
              SafPostModel res = SafPostModel.fromJson(responsePhone.data);

              setState(() {
                checkoutRequestId = res.checkoutRequestId;
              });
              print(res.responseCode);
              print(checkoutRequestId);
              if (res.responseCode == '0') {
                Navigator.of(context, rootNavigator: true).pop();
                setState(() {
                  buttonStateFloorPlan = true;
                });
                _show500();
                // _buttonTrue();
                print('object worked');
                _verify();
              } else {
                print('object failed');
                // _verify();
                setState(() {
                  buttonStateFloorPlan = true;
                });
                // _buttonTrue();
                _failed();

              }

              
              // _failed();
              // Navigator.of(context, rootNavigator: true).pop();
              // Navigator.of(context).pushNamed(
              //   '/home',
              //   // arguments: 'Hello there from the first page!',
              // );
              // Navigator.pop(context);
              //         // closeFunction();
              },
            // child: buttonStateFloorPlan ? Text(
            //   "Buy",
            //   style: TextStyle(color: Colors.white, fontSize: 20),
            // ) : CircularProgressIndicator(),
            child: Text(
              "Buy",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.green,
          )
        ]).show() 
        :
        Alert(
        context: context,
        title: "Floor Plan",
        desc: "Basic Plan. \n\n Enter your Mpesa number below",
        content: Column(
          children: <Widget>[
            
            TextField(
              // obscureText: true,
              // onChanged: (value) {
              //   Provider.of<AddTruckProvider>(context).setMessage2(null);
              // },
              controller: _controllerPhone,
              decoration: InputDecoration(
                icon: Icon(Icons.phone),
                labelText: 'Phone Number (254 712 345 678)',
                // errorText: Provider.of<AddTruckProvider>(context).getMessage2(),
              ),
              inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(12),
                  WhitelistingTextInputFormatter.digitsOnly,
                  
                ],
            ),
            // TextField(
            //   // obscureText: true,
            //   // onChanged: (value) {
            //   //   Provider.of<AddTruckProvider>(context).setMessage3(null);
            //   // },
            //   // controller: _controllerLocation,
            //   decoration: InputDecoration(
            //     icon: Icon(Icons.location_on),
            //     labelText: 'Current Location',
            //   ),
            // ),
          ],
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            // color: Color.fromRGBO(240, 9, 4, 1.0),
            color: Colors.red,
          ),

          DialogButton(
            child: buttonStateFloorPlan ? Text(
              "Test1",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ) : Text(
              "No1",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () async{
              // _buttonFalse();
              setState(() {
                buttonStateFloorPlan = true;
              });
              Navigator.of(context, rootNavigator: true).pop();
              _show500();
            },
            // color: Color.fromRGBO(240, 9, 4, 1.0),
            color: Colors.red,
          ),
          
          DialogButton(
            onPressed: () async{
              // _postTruck();
              // setState(() {
              //   buttonStateFloorPlan = false;
              // });

              // _buttonFalse();
              // print(buttonStateFloorPlan);
              // print("button pressed");
              // // _success();
              // Response responsePhone = await dio.post("http://mwambabuilders.com/mwambaApp/api/sendNumber", data: {"number": _controllerPhone.text});
              
              // SafPostModel res = SafPostModel.fromJson(responsePhone.data);

              // setState(() {
              //   checkoutRequestId = res.checkoutRequestId;
              // });
              // print(res.responseCode);
              // print(checkoutRequestId);
              // if (res.responseCode == '0') {
              //   _buttonTrue();
              //   print('object worked');
              //   _verify();
              // } else {
              //   print('object failed');
              //   // _verify();
              //   _buttonTrue();
              //   _failed();

              // }

              
              // _failed();
              // Navigator.of(context, rootNavigator: true).pop();
              // Navigator.of(context).pushNamed(
              //   '/home',
              //   // arguments: 'Hello there from the first page!',
              // );
              // Navigator.pop(context);
              //         // closeFunction();
              },
            // child: buttonStateFloorPlan ? Text(
            //   "Buy",
            //   style: TextStyle(color: Colors.white, fontSize: 20),
            // ) : CircularProgressIndicator(),
            child: CircularProgressIndicator(),
            color: Colors.green,
          )
        ]).show();
      
    
    
  }
  
  _showPlan() {
    // Alert(context: context, title: "RFLUTTER", desc: "Flutter is awesome.").show();
    buttonStateBasic ? Alert(
        context: context,
        title: "Basic Package",
        desc: "Basic Plan. \n 2d. \n\n Enter your Mpesa number below",
        content: Column(
          children: <Widget>[
            
            TextField(
              // obscureText: true,
              // onChanged: (value) {
              //   Provider.of<AddTruckProvider>(context).setMessage2(null);
              // },
              controller: _controllerPhoneBasic,
              decoration: InputDecoration(
                icon: Icon(Icons.phone),
                labelText: 'Phone Number (254 712 345 678)',
                // errorText: Provider.of<AddTruckProvider>(context).getMessage2(),
              ),
              inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(12),
                  WhitelistingTextInputFormatter.digitsOnly,
                  
                ],
            ),
            // TextField(
            //   // obscureText: true,
            //   // onChanged: (value) {
            //   //   Provider.of<AddTruckProvider>(context).setMessage3(null);
            //   // },
            //   // controller: _controllerLocation,
            //   decoration: InputDecoration(
            //     icon: Icon(Icons.location_on),
            //     labelText: 'Current Location',
            //   ),
            // ),
          ],
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            // color: Color.fromRGBO(240, 9, 4, 1.0),
            color: Colors.red,
          ),
          DialogButton(
            onPressed: () async{
                setState(() {
                  buttonStateBasic = false;
                });
                Navigator.of(context, rootNavigator: true).pop();
                _showPlan();

                print(buttonStateBasic);
                print("button pressed");
                // _success();
                Response responsePhone = await dio.post("http://mwambabuilders.com/mwambaApp/api/sendNumber", data: {"number": _controllerPhoneBasic.text});
                
                SafPostModel res = SafPostModel.fromJson(responsePhone.data);

                setState(() {
                  checkoutRequestId = res.checkoutRequestId;
                });
                print(res.responseCode);
                print(checkoutRequestId);
                if (res.responseCode == '0') {
                  Navigator.of(context, rootNavigator: true).pop();
                  setState(() {
                    buttonStateBasic = true;
                  });
                  _showPlan();
                  // _buttonTrue();
                  print('object worked');
                  _verifyBasic();
                } else {
                  print('object failed');
                  // _verify();
                  setState(() {
                    buttonStateBasic = true;
                  });
                  // _buttonTrue();
                  _failed();

                }
              },
            child: Text(
              "Buy",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.green,
          )
        ]).show() :
        Alert(
          context: context,
          title: "Basic Package",
          desc: "Basic Plan. \n 2d. \n\n Enter your Mpesa number below",
          content: Column(
            children: <Widget>[
              
              TextField(
                // obscureText: true,
                // onChanged: (value) {
                //   Provider.of<AddTruckProvider>(context).setMessage2(null);
                // },
                // controller: _controllerPhone,
                decoration: InputDecoration(
                  icon: Icon(Icons.phone),
                  labelText: 'Phone Number (254 712 345 678)',
                  // errorText: Provider.of<AddTruckProvider>(context).getMessage2(),
                ),
                inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(12),
                    WhitelistingTextInputFormatter.digitsOnly,
                    
                  ],
              ),
              // TextField(
              //   // obscureText: true,
              //   // onChanged: (value) {
              //   //   Provider.of<AddTruckProvider>(context).setMessage3(null);
              //   // },
              //   // controller: _controllerLocation,
              //   decoration: InputDecoration(
              //     icon: Icon(Icons.location_on),
              //     labelText: 'Current Location',
              //   ),
              // ),
            ],
          ),
          buttons: [
            DialogButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              // color: Color.fromRGBO(240, 9, 4, 1.0),
              color: Colors.red,
            ),
            DialogButton(
              onPressed: () {
                
                },
              child: CircularProgressIndicator(),
              color: Colors.green,
            )
          ]).show();
    
  }


  _showCad() {
    // Alert(context: context, title: "RFLUTTER", desc: "Flutter is awesome.").show();
    buttonStatePremium ? Alert(
        context: context,
        title: "Premium Package",
        desc: "3d. \n 2d. \n Floor Plan \n Elevation \n\n Enter your Mpesa number below",
        content: Column(
          children: <Widget>[
            
            TextField(
              // obscureText: true,
              // onChanged: (value) {
              //   Provider.of<AddTruckProvider>(context).setMessage2(null);
              // },
              controller: _controllerPhonePremium,
              decoration: InputDecoration(
                icon: Icon(Icons.phone),
                labelText: 'Phone Number (254 712 345 678)',
                // errorText: Provider.of<AddTruckProvider>(context).getMessage2(),
              ),
              inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(12),
                  WhitelistingTextInputFormatter.digitsOnly,
                  
                ],
            ),
            // TextField(
            //   // obscureText: true,
            //   // onChanged: (value) {
            //   //   Provider.of<AddTruckProvider>(context).setMessage3(null);
            //   // },
            //   // controller: _controllerLocation,
            //   decoration: InputDecoration(
            //     icon: Icon(Icons.location_on),
            //     labelText: 'Current Location',
            //   ),
            // ),
          ],
        ),
        buttons: [
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            // color: Color.fromRGBO(240, 9, 4, 1.0),
            color: Colors.red,
          ),
          DialogButton(
            onPressed: () async{
                setState(() {
                  buttonStatePremium = false;
                });
                Navigator.of(context, rootNavigator: true).pop();
                _showCad();

                print(buttonStatePremium);
                print("button pressed");
                // _success();
                Response responsePhone = await dio.post("http://mwambabuilders.com/mwambaApp/api/sendNumber", data: {"number": _controllerPhonePremium.text});
                
                SafPostModel res = SafPostModel.fromJson(responsePhone.data);

                setState(() {
                  checkoutRequestId = res.checkoutRequestId;
                });
                print(res.responseCode);
                print(checkoutRequestId);
                if (res.responseCode == '0') {
                  Navigator.of(context, rootNavigator: true).pop();
                  setState(() {
                    buttonStatePremium = true;
                  });
                  _showCad();
                  // _buttonTrue();
                  print('object worked');
                  _verifyPremium();
                } else {
                  print('object failed');
                  // _verify();
                  setState(() {
                    buttonStatePremium = true;
                  });
                  // _buttonTrue();
                  _failed();

                }
              },
            child: Text(
              "Buy",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.green,
          )
        ]).show() : 
        Alert(
          context: context,
          title: "Premium Package",
          desc: "3d. \n 2d. \n Floor Plan \n Elevation \n\n Enter your Mpesa number below",
          content: Column(
            children: <Widget>[
              
              TextField(
                // obscureText: true,
                // onChanged: (value) {
                //   Provider.of<AddTruckProvider>(context).setMessage2(null);
                // },
                // controller: _controllerPhone,
                decoration: InputDecoration(
                  icon: Icon(Icons.phone),
                  labelText: 'Phone Number (254 712 345 678)',
                  // errorText: Provider.of<AddTruckProvider>(context).getMessage2(),
                ),
                inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(12),
                    WhitelistingTextInputFormatter.digitsOnly,
                    
                  ],
              ),
              // TextField(
              //   // obscureText: true,
              //   // onChanged: (value) {
              //   //   Provider.of<AddTruckProvider>(context).setMessage3(null);
              //   // },
              //   // controller: _controllerLocation,
              //   decoration: InputDecoration(
              //     icon: Icon(Icons.location_on),
              //     labelText: 'Current Location',
              //   ),
              // ),
            ],
          ),
          buttons: [
            DialogButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              // color: Color.fromRGBO(240, 9, 4, 1.0),
              color: Colors.red,
            ),
            DialogButton(
              onPressed: () {
                
                },
              child: CircularProgressIndicator(),
              color: Colors.green,
            )
          ]).show();
    
  }

  _verify(){
    buttonPlanVerifyDownload ? Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Is Being Processed",
      // desc: "Download Should Begin Shortly.",
      buttons: [
        DialogButton(
          child: Text(
            "Verify",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          // onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          // checReq = checkoutRequestId,
          onPressed: () async{
            print(checkoutRequestId);
            setState(() {
              buttonPlanVerifyDownload = false;
            });
            Navigator.of(context, rootNavigator: true).pop();
            _verify();
            Response responseVerify = await dio.post("http://mwambabuilders.com/mwambaApp/api/mpesaVerify", data: {"CheckoutRequestID": checkoutRequestId});
            
            SafVerifyModel res = SafVerifyModel.fromJson(responseVerify.data);
            // setState(() {
            //   checkoutRequestId = "";
            // });
            print(res.resultCode);
            print("hello");
            if (res.resultCode == "0") {
              Navigator.of(context, rootNavigator: true).pop();
              setState(() {
                buttonPlanVerifyDownload = true;
              });
              _verify();
              print("hello 2");
              _success();
            } else{
              Navigator.of(context, rootNavigator: true).pop();
              setState(() {
                buttonPlanVerifyDownload = true;
              });
              _verify();
              print("hello 2");
            }

          },
          width: 120,
        )
      ],
    ).show() :
    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Is Being Processed",
      // desc: "Download Should Begin Shortly.",
      buttons: [
        
        DialogButton(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green)
          ),
          // onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          // checReq = checkoutRequestId,
          onPressed: () async{
            // print(checkoutRequestId);
            // Response responseVerify = await dio.post("http://mwambabuilders.com/mwambaApp/api/mpesaVerify", data: {"CheckoutRequestID": checkoutRequestId});
            
            // SafVerifyModel res = SafVerifyModel.fromJson(responseVerify.data);
            // // setState(() {
            // //   checkoutRequestId = "";
            // // });
            // print(res.resultCode);
            // print("hello");
            // if (res.resultCode == "0") {
            //   print("hello 2");
            //   _success();
            // }

          },
          width: 120,
        )
      ],
    ).show();
  }

  _verifyBasic(){
    buttonBasicVerifyDownload ? Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Is Being Processed",
      // desc: "Download Should Begin Shortly.",
      buttons: [
        DialogButton(
          child: Text(
            "Verify",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          // onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          // checReq = checkoutRequestId,
          onPressed: () async{
            print(checkoutRequestId);
            setState(() {
              buttonBasicVerifyDownload = false;
            });
            Navigator.of(context, rootNavigator: true).pop();
            _verifyBasic();
            Response responseVerify = await dio.post("http://mwambabuilders.com/mwambaApp/api/mpesaVerify", data: {"CheckoutRequestID": checkoutRequestId});
            
            SafVerifyModel res = SafVerifyModel.fromJson(responseVerify.data);
            // setState(() {
            //   checkoutRequestId = "";
            // });
            print(res.resultCode);
            print("hello");
            if (res.resultCode == "0") {
              Navigator.of(context, rootNavigator: true).pop();
              setState(() {
                buttonBasicVerifyDownload = true;
              });
              _verifyBasic();
              print("hello 2");
              _successBasic();
            } else{
              Navigator.of(context, rootNavigator: true).pop();
              setState(() {
                buttonBasicVerifyDownload = true;
              });
              _verifyBasic();
              print("hello 2");
            }

          },
          width: 120,
        )
      ],
    ).show() :
    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Is Being Processed",
      // desc: "Download Should Begin Shortly.",
      buttons: [
        
        DialogButton(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green)
          ),
          // onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          // checReq = checkoutRequestId,
          onPressed: () async{
            // print(checkoutRequestId);
            // Response responseVerify = await dio.post("http://mwambabuilders.com/mwambaApp/api/mpesaVerify", data: {"CheckoutRequestID": checkoutRequestId});
            
            // SafVerifyModel res = SafVerifyModel.fromJson(responseVerify.data);
            // // setState(() {
            // //   checkoutRequestId = "";
            // // });
            // print(res.resultCode);
            // print("hello");
            // if (res.resultCode == "0") {
            //   print("hello 2");
            //   _success();
            // }

          },
          width: 120,
        )
      ],
    ).show();
  }

  _verifyPremium(){
    buttonPremiumVerifyDownload ? Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Is Being Processed",
      // desc: "Download Should Begin Shortly.",
      buttons: [
        DialogButton(
          child: Text(
            "Verify",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          // onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          // checReq = checkoutRequestId,
          onPressed: () async{
            print(checkoutRequestId);
            setState(() {
              buttonPremiumVerifyDownload = false;
            });
            Navigator.of(context, rootNavigator: true).pop();
            _verifyPremium();
            Response responseVerify = await dio.post("http://mwambabuilders.com/mwambaApp/api/mpesaVerify", data: {"CheckoutRequestID": checkoutRequestId});
            
            SafVerifyModel res = SafVerifyModel.fromJson(responseVerify.data);
            // setState(() {
            //   checkoutRequestId = "";
            // });
            print(res.resultCode);
            print("hello");
            if (res.resultCode == "0") {
              Navigator.of(context, rootNavigator: true).pop();
              setState(() {
                buttonPremiumVerifyDownload = true;
              });
              _verifyPremium();
              print("hello 2");
              _successPremium();
            } else {
              Navigator.of(context, rootNavigator: true).pop();
              setState(() {
                buttonPremiumVerifyDownload = true;
              });
              _verifyPremium();
              print("hello 2");
            }

          },
          width: 120,
        )
      ],
    ).show() :
    Alert(
      context: context,
      type: AlertType.info,
      title: "Transaction Is Being Processed",
      // desc: "Download Should Begin Shortly.",
      buttons: [
        
        DialogButton(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green)
          ),
          // onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          // checReq = checkoutRequestId,
          onPressed: () async{
            // print(checkoutRequestId);
            // Response responseVerify = await dio.post("http://mwambabuilders.com/mwambaApp/api/mpesaVerify", data: {"CheckoutRequestID": checkoutRequestId});
            
            // SafVerifyModel res = SafVerifyModel.fromJson(responseVerify.data);
            // // setState(() {
            // //   checkoutRequestId = "";
            // // });
            // print(res.resultCode);
            // print("hello");
            // if (res.resultCode == "0") {
            //   print("hello 2");
            //   _success();
            // }

          },
          width: 120,
        )
      ],
    ).show();
  }

  _success() {
    
        buttonPlanDownload ? Alert(
          context: context,
          type: AlertType.success,
          title: "Transaction Successful \n \n $progressFloorPlan%",
          desc: isDownloadedFloorPlan ? 'File Downloaded! You can see your file in the application\'s directory \n \n $directoryFloorPlan' : "Click Button To Download.",
          buttons: [
            DialogButton(
              child: Row(
                children: [
                  Text(
                    "Download File",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              // onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              onPressed: () async{
                setState(() {
                  buttonPlanDownload = false;
                });
                Navigator.of(context, rootNavigator: true).pop();
                _success();
                downloadFileFloorPlan(uriFloorPlan, filenameFloorPlan, resultFloorPlan);
                // setState(() {
                //   isDownloadedFloorPlan = false;
                // });
              },
              width: 120,
            )
          ],
        ).show() :
        Alert(
          context: context,
          type: AlertType.success,
          title: "File is Downloading",
          desc: isDownloadedFloorPlan ? 'File Downloaded! You can see your file in the application\'s directory \n \n $directoryFloorPlan' : "Close Dialogs To View Download.",
          buttons: [
            DialogButton(
              child: Column(
                children: [
                  Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              // onPressed: () async{
                
              //   downloadFileFloorPlan(uriFloorPlan, filenameFloorPlan, resultFloorPlan);
              //   // setState(() {
              //   //   isDownloadedFloorPlan = false;
              //   // });
              // },
              width: 120,
            )
          ],
        ).show();
    
  }

  _successBasic() {
    
        buttonBasicDownload ? Alert(
          context: context,
          type: AlertType.success,
          title: "Transaction Successful \n \n $progressBasic%",
          desc: isDownloadedBasic ? 'File Downloaded! You can see your file in the application\'s directory \n \n $directoryFloorPlan' : "Click Button To Download.",
          buttons: [
            DialogButton(
              child: Row(
                children: [
                  Text(
                    "Download File",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              // onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              onPressed: () async{
                setState(() {
                  buttonBasicDownload = false;
                });
                Navigator.of(context, rootNavigator: true).pop();
                _successBasic();
                downloadFileBasic(uriBasic, filenameBasic, resultBasic);
                // setState(() {
                //   isDownloadedFloorPlan = false;
                // });
              },
              width: 120,
            )
          ],
        ).show() :
        Alert(
          context: context,
          type: AlertType.success,
          title: "File is Downloading",
          desc: isDownloadedBasic ? 'File Downloaded! You can see your file in the application\'s directory \n \n $directoryFloorPlan' : "Close Dialogs To View Download.",
          buttons: [
            DialogButton(
              child: Column(
                children: [
                  Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              // onPressed: () async{
                
              //   downloadFileFloorPlan(uriFloorPlan, filenameFloorPlan, resultFloorPlan);
              //   // setState(() {
              //   //   isDownloadedFloorPlan = false;
              //   // });
              // },
              width: 120,
            )
          ],
        ).show();
    
  }

  _successPremium() {
    
        buttonPremiumDownload ? Alert(
          context: context,
          type: AlertType.success,
          title: "Transaction Successful \n \n $progressPremium%",
          desc: isDownloadedPremium ? 'File Downloaded! You can see your file in the application\'s directory \n \n $directoryPremium' : "Click Button To Download.",
          buttons: [
            DialogButton(
              child: Row(
                children: [
                  Text(
                    "Download File",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              // onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              onPressed: () async{
                setState(() {
                  buttonPremiumDownload = false;
                });
                Navigator.of(context, rootNavigator: true).pop();
                _successPremium();
                downloadFilePremium(uriPremium, filenamePremium, resultPremium);
                // setState(() {
                //   isDownloadedFloorPlan = false;
                // });
              },
              width: 120,
            )
          ],
        ).show() :
        Alert(
          context: context,
          type: AlertType.success,
          title: "File is Downloading",
          desc: isDownloadedPremium ? 'File Downloaded! You can see your file in the application\'s directory \n \n $directoryPremium' : "Close Dialogs To View Download.",
          buttons: [
            DialogButton(
              child: Column(
                children: [
                  Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              // onPressed: () async{
                
              //   downloadFileFloorPlan(uriFloorPlan, filenameFloorPlan, resultFloorPlan);
              //   // setState(() {
              //   //   isDownloadedFloorPlan = false;
              //   // });
              // },
              width: 120,
            )
          ],
        ).show();
    
  }

  _failed(){
    Alert(
      context: context,
      type: AlertType.error,
      title: "Transaction Failed",
      desc: "Network Error Kindly Try Again.",
      buttons: [
        DialogButton(
          child: Text(
            "COOL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          width: 120,
        )
      ],
    ).show();
  }
  

  
}

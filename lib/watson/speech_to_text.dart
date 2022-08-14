import 'dart:convert';

import 'iam_option.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

class STTResult {
  final int resultIndex;
  final List<String> transcripts;
  final List<double> confidences;

  const STTResult({
    this.resultIndex = 0,
    required this.transcripts,
    required this.confidences,
  });

  factory STTResult.fromJson(Map<String, dynamic> json) {

    var it = json['results'].iterator;
    List<String> tempT = [];
    List<double> tempC = [];
    while(it.moveNext()){
      Map<String,dynamic> currentPhase = it.current;
      String transcript = currentPhase['alternatives'][0]['transcript'] as String;
      tempT.add(transcript.substring(0,transcript.length-1));
      tempC.add(currentPhase['alternatives'][0]['confidence'] as double);
    }

    return STTResult(
      transcripts: tempT,
      confidences: tempC,
    );
  }

  String getAllTranscript(){
    return '${transcripts.join(", ")}.';
  }
}

class SpeechToText {
  String urlBase = "https://api.eu-gb.speech-to-text.watson.cloud.ibm.com";
  IamOptions iamOptions;
  String contentType;
  String model;
  File audioFile;
  bool lowLatency;

  //Json pack to init and end web socket
  //final String startMessage = "{action: 'start'}";
  //final String stopMessage = "{action: 'stop'}";

  SpeechToText(
      {required this.iamOptions,
        required this.audioFile,
        this.contentType = "audio/wav",
        this.model = "en-US_BroadbandModel",
        this.lowLatency = false});
/*
  void setModel(String m) {
    this.model = m;
  }
*/
  String _getUrl(method, {param = ""}) {
    String url = iamOptions.url;
    if (iamOptions.url == "") {
      url = urlBase;
    }
    return "$url/v1/$method$param";
  }


  Future<STTResult> run() async {
    String token = iamOptions.accessToken;
    //String STTResult = 'Ibm Watson initial failure';
    var response = await http.post(
      Uri.parse(_getUrl("recognize", param: "?model=$model&low_latency=$lowLatency")),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: contentType,
      },
      body: await audioFile.readAsBytes()
    );

    Map<String, dynamic> parsed = Map.castFrom(json.decode(response.body));

    if(parsed.containsKey('error')){
      String error = parsed['error'];
      int errCode = parsed['code'];
      String description = parsed['code_description'];
      throw Exception("$error,error code: $errCode, $description");
    }

    /*
    if(result.confidence<0.2){
      double confidence = result.confidence;
      return "IBM Watson could not understand what you mean.(Confidence of recognition is $confidence)";
    }
    */
    return STTResult.fromJson(parsed);

    /*
    final channel = WebSocketChannel.connect(
      Uri.parse(_getUrl("recognize", param: "?access_token=$token&model=$model")),
    );
    channel.stream.listen(
          (data) {
        print(data);
      },
      onOpen: (data)=> onOpen(channel),
      onError: (error) => print(error),
      onMessage:(data)=> data.
    );
    */
  }
/*
  Future<void> onOpen(channel) async {
    channel.sink.add(startMessage);
    Uint8List biAudio = await this.aduioFile.readAsBytes();
    channel.sink.add(biAudio);
    channel.sink.add(stopMessage);
  }
*/

/*
  Future<Uint8List> toSpeech(String text) async {
    String token = this.iamOptions.accessToken;
    var response = await http.post(
      Uri.parse(_getUrl("recognize", param: "&model=$model")),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json",
        //'Accept': this.content_type
      },
      body: '{"text":"$text"}',
    );
    return response.bodyBytes;
  }

  Future<List<Voice>> getListVoices() async {
    String token = this.iamOptions.accessToken;
    var response = await http.get(_getUrl("voices"), headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
    });
    List<Voice> resp = [];
    if (response.statusCode == 200) {
      Map result = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> data = result['voices'];
      for (Map d in data) {
        resp.add(new Voice(d));
      }
    }
    return resp;
  }

 */
}
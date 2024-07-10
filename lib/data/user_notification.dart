import 'package:supa_architecture/json/json.dart';
import 'package:supa_architecture/supa_architecture.dart';

class UserNotification extends JsonModel {
  JsonNumber id = JsonNumber("id");

  JsonString title = JsonString("title");
  JsonString titleWeb = JsonString("titleWeb");
  JsonString titleMobile = JsonString("titleMobile");

  JsonString content = JsonString("content");
  JsonString contentWeb = JsonString("contentWeb");
  JsonString contentMobile = JsonString("contentMobile");

  JsonString link = JsonString("link");
  JsonString linkWeb = JsonString("linkWeb");
  JsonString linkMobile = JsonString("linkMobile");

  @override
  List<JsonField> get fields => [
        id,
        title,
        titleWeb,
        titleMobile,
        content,
        contentWeb,
        contentMobile,
        link,
        linkWeb,
        linkMobile,
      ];
}
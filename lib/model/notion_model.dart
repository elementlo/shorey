import 'package:spark_list/model/model.dart';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/13
/// Description:
///

class NotionUsersInfo {
  String? object;
  List<Results>? results;
  Null? nextCursor;
  bool? hasMore;

  NotionUsersInfo({this.object, this.results, this.nextCursor, this.hasMore});

  NotionUsersInfo.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
    nextCursor = json['next_cursor'];
    hasMore = json['has_more'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object'] = this.object;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['next_cursor'] = this.nextCursor;
    data['has_more'] = this.hasMore;
    return data;
  }
}

class Results with ModelMixin {
  String? object;
  String? id;
  String? name;
  String? avatarUrl;
  String? type;
  Person? person;
  Bot? bot;
  String? token;

  Results(
      {this.object,
      this.id,
      this.token,
      this.name,
      this.avatarUrl,
      this.type,
      this.person,
      this.bot});

  Results.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    id = json['id'];
    name = json['name'];
    avatarUrl = json['avatar_url'];
    type = json['type'];
    token = json['token'];
    person =
        json['person'] != null ? new Person.fromJson(json['person']) : null;
    bot = json['bot'] != null ? new Bot.fromJson(json['bot']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object'] = this.object;
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar_url'] = this.avatarUrl;
    data['type'] = this.type;
    data['token'] = this.token;
    if (this.person != null) {
      data['person'] = this.person!.toJson();
    }
    if (this.bot != null) {
      data['bot'] = this.bot!.toJson();
    }
    return data;
  }
}

class Person {
  String? email;

  Person({this.email});

  Person.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}

class Bot {
  Owner? owner;

  Bot({this.owner});

  Bot.fromJson(Map<String, dynamic> json) {
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    return data;
  }
}

class Owner {
  String? type;
  bool? workspace;

  Owner({this.type, this.workspace});

  Owner.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    workspace = json['workspace'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['workspace'] = this.workspace;
    return data;
  }
}




///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/1/25
/// Description: 
///

class NotionPage {
  String? object;
  String? id;
  String? createdTime;
  String? lastEditedTime;
  Cover? cover;
  Icon? icon;
  Parent? parent;
  bool? archived;
  Properties? properties;
  String? url;

  NotionPage(
      {this.object,
        this.id,
        this.createdTime,
        this.lastEditedTime,
        this.cover,
        this.icon,
        this.parent,
        this.archived,
        this.properties,
        this.url});

  NotionPage.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    id = json['id'];
    createdTime = json['created_time'];
    lastEditedTime = json['last_edited_time'];
    cover = json['cover'] != null ? new Cover.fromJson(json['cover']) : null;
    icon = json['icon'] != null ? new Icon.fromJson(json['icon']) : null;
    parent =
    json['parent'] != null ? new Parent.fromJson(json['parent']) : null;
    archived = json['archived'];
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object'] = this.object;
    data['id'] = this.id;
    data['created_time'] = this.createdTime;
    data['last_edited_time'] = this.lastEditedTime;
    if (this.cover != null) {
      data['cover'] = this.cover!.toJson();
    }
    if (this.icon != null) {
      data['icon'] = this.icon!.toJson();
    }
    if (this.parent != null) {
      data['parent'] = this.parent!.toJson();
    }
    data['archived'] = this.archived;
    if (this.properties != null) {
      data['properties'] = this.properties!.toJson();
    }
    data['url'] = this.url;
    return data;
  }
}

class Cover {
  String? type;
  External? external;

  Cover({this.type, this.external});

  Cover.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    external = json['external'] != null
        ? new External.fromJson(json['external'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.external != null) {
      data['external'] = this.external!.toJson();
    }
    return data;
  }
}

class External {
  String? url;

  External({this.url});

  External.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}

class Icon {
  String? type;
  String? emoji;

  Icon({this.type, this.emoji});

  Icon.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    emoji = json['emoji'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['emoji'] = this.emoji;
    return data;
  }
}

class Parent {
  String? type;
  bool? workspace;

  Parent({this.type, this.workspace});

  Parent.fromJson(Map<String, dynamic> json) {
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

class Properties {
  Title? title;

  Properties({this.title});

  Properties.fromJson(Map<String, dynamic> json) {
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    return data;
  }
}

class Title {
  String? id;
  String? type;
  List<TitleInfo>? title;

  Title({this.id, this.type, this.title});

  Title.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    if (json['title'] != null) {
      title = <TitleInfo>[];
      json['title'].forEach((v) {
        title!.add(new TitleInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.title != null) {
      data['title'] = this.title!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TitleInfo {
  String? type;
  Text? text;
  Annotations? annotations;
  String? plainText;
  Null? href;

  TitleInfo({this.type, this.text, this.annotations, this.plainText, this.href});

  TitleInfo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    text = json['text'] != null ? new Text.fromJson(json['text']) : null;
    annotations = json['annotations'] != null
        ? new Annotations.fromJson(json['annotations'])
        : null;
    plainText = json['plain_text'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.text != null) {
      data['text'] = this.text!.toJson();
    }
    if (this.annotations != null) {
      data['annotations'] = this.annotations!.toJson();
    }
    data['plain_text'] = this.plainText;
    data['href'] = this.href;
    return data;
  }
}

class Text {
  String? content;
  Null? link;

  Text({this.content, this.link});

  Text.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['link'] = this.link;
    return data;
  }
}

class Annotations {
  bool? bold;
  bool? italic;
  bool? strikethrough;
  bool? underline;
  bool? code;
  String? color;

  Annotations(
      {this.bold,
        this.italic,
        this.strikethrough,
        this.underline,
        this.code,
        this.color});

  Annotations.fromJson(Map<String, dynamic> json) {
    bold = json['bold'];
    italic = json['italic'];
    strikethrough = json['strikethrough'];
    underline = json['underline'];
    code = json['code'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bold'] = this.bold;
    data['italic'] = this.italic;
    data['strikethrough'] = this.strikethrough;
    data['underline'] = this.underline;
    data['code'] = this.code;
    data['color'] = this.color;
    return data;
  }
}

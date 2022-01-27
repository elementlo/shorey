class NotionDatabase {
  String? object;
  String? id;
  Cover? cover;
  Icon? icon;
  String? createdTime;
  String? lastEditedTime;
  List<Title>? title;
  Properties? properties;
  Parent? parent;
  String? url;

  NotionDatabase(
      {this.object,
      this.id,
      this.cover,
      this.icon,
      this.createdTime,
      this.lastEditedTime,
      this.title,
      this.properties,
      this.parent,
      this.url});

  NotionDatabase.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    id = json['id'];
    cover = json['cover'] != null ? new Cover.fromJson(json['cover']) : null;
    icon = json['icon'] != null ? new Icon.fromJson(json['icon']) : null;
    createdTime = json['created_time'];
    lastEditedTime = json['last_edited_time'];
    if (json['title'] != null) {
      title = <Title>[];
      json['title'].forEach((v) {
        title!.add(new Title.fromJson(v));
      });
    }
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
    parent =
        json['parent'] != null ? new Parent.fromJson(json['parent']) : null;
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object'] = this.object;
    data['id'] = this.id;
    if (this.cover != null) {
      data['cover'] = this.cover!.toJson();
    }
    if (this.icon != null) {
      data['icon'] = this.icon!.toJson();
    }
    data['created_time'] = this.createdTime;
    data['last_edited_time'] = this.lastEditedTime;
    if (this.title != null) {
      data['title'] = this.title!.map((v) => v.toJson()).toList();
    }
    if (this.properties != null) {
      data['properties'] = this.properties!.toJson();
    }
    if (this.parent != null) {
      data['parent'] = this.parent!.toJson();
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

class Title {
  String? type;
  Text? text;
  Annotations? annotations;
  String? plainText;
  String? href;

  Title({this.type, this.text, this.annotations, this.plainText, this.href});

  Title.fromJson(Map<String, dynamic> json) {
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
  String? link;

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

class Properties {
  Tags? tags;
  Name? name;

  Properties({this.tags, this.name});

  Properties.fromJson(Map<String, dynamic> json) {
    tags = json['Tags'] != null ? new Tags.fromJson(json['Tags']) : null;
    name = json['Name'] != null ? new Name.fromJson(json['Name']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tags != null) {
      data['Tags'] = this.tags!.toJson();
    }
    if (this.name != null) {
      data['Name'] = this.name!.toJson();
    }
    return data;
  }
}

class Tags {
  String? id;
  String? name;
  String? type;
  MultiSelect? multiSelect;

  Tags({this.id, this.name, this.type, this.multiSelect});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    multiSelect = json['multi_select'] != null
        ? new MultiSelect.fromJson(json['multi_select'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.multiSelect != null) {
      data['multi_select'] = this.multiSelect!.toJson();
    }
    return data;
  }
}

class MultiSelect {
  List<Options>? options;

  MultiSelect({this.options});

  MultiSelect.fromJson(Map<String, dynamic> json) {
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? id;
  String? name;
  String? color;

  Options({this.id, this.name, this.color});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['color'] = this.color;
    return data;
  }
}

class Name {
  String? id;
  String? name;
  String? type;
  Title? title;

  Name({this.id, this.name, this.type, this.title});

  Name.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    return data;
  }
}

class NameTitle {
  NameTitle();

  NameTitle.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class Parent {
  String? type;
  String? pageId;

  Parent({this.type, this.pageId});

  Parent.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    pageId = json['page_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['page_id'] = this.pageId;
    return data;
  }
}

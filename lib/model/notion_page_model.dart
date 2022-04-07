class NotionPage {
  String? object;
  String? id;
  String? createdTime;
  String? lastEditedTime;
  CreatedBy? createdBy;
  CreatedBy? lastEditedBy;
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
        this.createdBy,
        this.lastEditedBy,
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
    createdBy = json['created_by'] != null
        ? new CreatedBy.fromJson(json['created_by'])
        : null;
    lastEditedBy = json['last_edited_by'] != null
        ? new CreatedBy.fromJson(json['last_edited_by'])
        : null;
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
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy!.toJson();
    }
    if (this.lastEditedBy != null) {
      data['last_edited_by'] = this.lastEditedBy!.toJson();
    }
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

class CreatedBy {
  String? object;
  String? id;

  CreatedBy({this.object, this.id});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object'] = this.object;
    data['id'] = this.id;
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
  String? databaseId;

  Parent({this.type, this.databaseId});

  Parent.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    databaseId = json['database_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['database_id'] = this.databaseId;
    return data;
  }
}

class Properties {
  Links? links;
  Status? status;
  Tags? tags;
  Duration? duration;
  ReminderTime? reminderTime;
  Brief? brief;

  Properties(
      {this.links,
        this.status,
        this.tags,
        this.duration,
        this.reminderTime,
        this.brief});

  Properties.fromJson(Map<String, dynamic> json) {
    links = json['Links'] != null ? new Links.fromJson(json['Links']) : null;
    status =
    json['Status'] != null ? new Status.fromJson(json['Status']) : null;
    tags = json['Tags'] != null ? new Tags.fromJson(json['Tags']) : null;
    duration = json['Duration'] != null
        ? new Duration.fromJson(json['Duration'])
        : null;
    reminderTime = json['Reminder Time'] != null
        ? new ReminderTime.fromJson(json['Reminder Time'])
        : null;
    brief = json['Name'] != null ? new Brief.fromJson(json['Name']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.links != null) {
      data['Links'] = this.links!.toJson();
    }
    if (this.status != null) {
      data['Status'] = this.status!.toJson();
    }
    if (this.tags != null) {
      data['Tags'] = this.tags!.toJson();
    }
    if (this.duration != null) {
      data['Duration'] = this.duration!.toJson();
    }
    if (this.reminderTime != null) {
      data['Reminder Time'] = this.reminderTime!.toJson();
    }
    if (this.brief != null) {
      data['Name'] = this.brief!.toJson();
    }
    return data;
  }
}

class Links {
  String? id;
  String? type;
  String? url;

  Links({this.id, this.type, this.url});

  Links.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}

class Status {
  String? id;
  String? type;
  Select? select;

  Status({this.id, this.type, this.select});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    select =
    json['select'] != null ? new Select.fromJson(json['select']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.select != null) {
      data['select'] = this.select!.toJson();
    }
    return data;
  }
}

class Select {
  String? id;
  String? name;
  String? color;

  Select({this.id, this.name, this.color});

  Select.fromJson(Map<String, dynamic> json) {
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

class Tags {
  String? id;
  String? type;
  List<MultiSelect>? multiSelect;

  Tags({this.id, this.type, this.multiSelect});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    if (json['multi_select'] != null) {
      multiSelect = <MultiSelect>[];
      json['multi_select'].forEach((v) {
        multiSelect!.add(new MultiSelect.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.multiSelect != null) {
      data['multi_select'] = this.multiSelect!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Duration {
  String? id;
  String? type;
  Date? date;

  Duration({this.id, this.type, this.date});

  Duration.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    date = json['date'] != null ? new Date.fromJson(json['date']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.date != null) {
      data['date'] = this.date!.toJson();
    }
    return data;
  }
}

class Date {
  String? start;
  String? end;
  String? timeZone;

  Date({this.start, this.end, this.timeZone});

  Date.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    timeZone = json['time_zone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    data['time_zone'] = this.timeZone;
    return data;
  }
}

class ReminderTime {
  String? id;
  String? type;
  Date? date;

  ReminderTime({this.id, this.type, this.date});

  ReminderTime.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    date = json['date'] != null ? new Date.fromJson(json['date']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.date != null) {
      data['date'] = this.date!.toJson();
    }
    return data;
  }
}

class Brief {
  String? id;
  String? type;
  List<Title>? title;

  Brief({this.id, this.type, this.title});

  Brief.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    if (json['title'] != null) {
      title = <Title>[];
      json['title'].forEach((v) {
        title!.add(new Title.fromJson(v));
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

class MultiSelect {
  String? id;
  String? name;
  String? color;

  MultiSelect({this.id, this.name, this.color});

  MultiSelect.fromJson(Map<String, dynamic> json) {
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
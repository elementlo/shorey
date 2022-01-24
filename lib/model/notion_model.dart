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

class Results {
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

class NotionDatabase {
  String? object;
  String? id;
  String? createdTime;
  String? lastEditedTime;
  List<Title>? title;
  Properties? properties;

  NotionDatabase(
      {this.object,
      this.id,
      this.createdTime,
      this.lastEditedTime,
      this.title,
      this.properties});

  NotionDatabase.fromJson(Map<String, dynamic> json) {
    object = json['object'];
    id = json['id'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['object'] = this.object;
    data['id'] = this.id;
    data['created_time'] = this.createdTime;
    data['last_edited_time'] = this.lastEditedTime;
    if (this.title != null) {
      data['title'] = this.title!.map((v) => v.toJson()).toList();
    }
    if (this.properties != null) {
      data['properties'] = this.properties!.toJson();
    }
    return data;
  }
}

class Title {
  String? type;
  Text? text;
  Annotations? annotations;
  String? plainText;
  Null? href;

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

class Properties {
  Score5? score5;
  Score5? type;
  Score5? publisher;
  Summary? summary;
  PublishingReleaseDate? publishingReleaseDate;
  Link? link;
  Read? read;
  Score5? status;
  Author? author;
  Name? name;

  Properties(
      {this.score5,
      this.type,
      this.publisher,
      this.summary,
      this.publishingReleaseDate,
      this.link,
      this.read,
      this.status,
      this.author,
      this.name});

  Properties.fromJson(Map<String, dynamic> json) {
    score5 =
        json['Score /5'] != null ? new Score5.fromJson(json['Score /5']) : null;
    type = json['Type'] != null ? new Score5.fromJson(json['Type']) : null;
    publisher = json['Publisher'] != null
        ? new Score5.fromJson(json['Publisher'])
        : null;
    summary =
        json['Summary'] != null ? new Summary.fromJson(json['Summary']) : null;
    publishingReleaseDate = json['Publishing/Release Date'] != null
        ? new PublishingReleaseDate.fromJson(json['Publishing/Release Date'])
        : null;
    link = json['Link'] != null ? new Link.fromJson(json['Link']) : null;
    read = json['Read'] != null ? new Read.fromJson(json['Read']) : null;
    status =
        json['Status'] != null ? new Score5.fromJson(json['Status']) : null;
    author =
        json['Author'] != null ? new Author.fromJson(json['Author']) : null;
    name = json['Name'] != null ? new Name.fromJson(json['Name']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.score5 != null) {
      data['Score /5'] = this.score5!.toJson();
    }
    if (this.type != null) {
      data['Type'] = this.type!.toJson();
    }
    if (this.publisher != null) {
      data['Publisher'] = this.publisher!.toJson();
    }
    if (this.summary != null) {
      data['Summary'] = this.summary!.toJson();
    }
    if (this.publishingReleaseDate != null) {
      data['Publishing/Release Date'] = this.publishingReleaseDate!.toJson();
    }
    if (this.link != null) {
      data['Link'] = this.link!.toJson();
    }
    if (this.read != null) {
      data['Read'] = this.read!.toJson();
    }
    if (this.status != null) {
      data['Status'] = this.status!.toJson();
    }
    if (this.author != null) {
      data['Author'] = this.author!.toJson();
    }
    if (this.name != null) {
      data['Name'] = this.name!.toJson();
    }
    return data;
  }
}

class Score5 {
  String? id;
  String? type;
  Select? select;

  Score5({this.id, this.type, this.select});

  Score5.fromJson(Map<String, dynamic> json) {
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
  List<Options>? options;

  Select({this.options});

  Select.fromJson(Map<String, dynamic> json) {
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

class Summary {
  String? id;
  String? type;
  Text? text;

  Summary({this.id, this.type, this.text});

  Summary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    text = json['text'] != null ? new Text.fromJson(json['text']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.text != null) {
      data['text'] = this.text!.toJson();
    }
    return data;
  }
}

class PublishingReleaseDate {
  String? id;
  String? type;
  Text? date;

  PublishingReleaseDate({this.id, this.type, this.date});

  PublishingReleaseDate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    date = json['date'] != null ? new Text.fromJson(json['date']) : null;
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

class Link {
  String? id;
  String? type;
  Text? url;

  Link({this.id, this.type, this.url});

  Link.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    url = json['url'] != null ? new Text.fromJson(json['url']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.url != null) {
      data['url'] = this.url!.toJson();
    }
    return data;
  }
}

class Read {
  String? id;
  String? type;
  Text? checkbox;

  Read({this.id, this.type, this.checkbox});

  Read.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    checkbox =
        json['checkbox'] != null ? new Text.fromJson(json['checkbox']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.checkbox != null) {
      data['checkbox'] = this.checkbox!.toJson();
    }
    return data;
  }
}

class Author {
  String? id;
  String? type;
  Select? multiSelect;

  Author({this.id, this.type, this.multiSelect});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    multiSelect = json['multi_select'] != null
        ? new Select.fromJson(json['multi_select'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.multiSelect != null) {
      data['multi_select'] = this.multiSelect!.toJson();
    }
    return data;
  }
}

class Name {
  String? id;
  String? type;
  Text? title;

  Name({this.id, this.type, this.title});

  Name.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'] != null ? new Text.fromJson(json['title']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    return data;
  }
}

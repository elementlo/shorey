import 'dart:convert';

///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/2/24
/// Description:
///

class NotionDatabaseTemplate {
  static dynamic taskList(String pageId) {
    return jsonDecode('''
{
    "parent": {
        "type": "page_id",
        "page_id": "${pageId}"
    },
    "title": [
        {
            "type": "text",
            "text": {
                "content": "Task List",
                "link": null
            }
        }
    ],
    "properties": {
        "Title": {
            "title": {}
        },
        "Note": {
            "rich_text": {}
        },
        "Duration": {
            "date": {}
        },
        "Status": {
            "select": {
                "options": [
                    {
                        "name": "On Going",
                        "color": "blue"
                    },
                    {
                        "name": "Archived",
                        "color": "orange"
                    },
                    {
                        "name": "Later",
                        "color": "purple"
                    },
                    {
                        "name": "Deleted",
                        "color": "gray"
                    }
                ]
            }
        },
        "Tags": {
            "type": "multi_select",
            "multi_select": {
                "options": []
            }
        },
        "Links": {
            "url": {}
        }
    }
}
    ''');
  }

  static dynamic taskItem(String databaseId) {
    return jsonDecode('''
 {
    "parent": {
        "database_id": "${databaseId}"
    },
    "properties": {
        "Title": {
            "title": [
                {
                    "text": {
                        "content": "New Media Article"
                    }
                }
            ]
        },
        "Status": {
            "select": {
                "name": "On Going"
            }
        },
        "Tags":{
            "multi_select":[
                {
                    "name": "category"
                }
            ]
        },
        "Duration": {
            "date": {
                "start": "2020-12-08T12:00:00Z",
                "end": null
            }
        },
        "Links": {
            "url": "https://www.nytimes.com/2018/10/21/opinion/who-will-teach-silicon-valley-to-be-ethical.html"
        },
        "Note": {
            "rich_text": [
                {
                    "type": "text",
                    "text": {
                        "content": "Some think chief ethics officers could help technology companies navigate political and social questions.",
                        "link": null
                    },
                    "annotations": {
                        "bold": false,
                        "italic": false,
                        "strikethrough": false,
                        "underline": false,
                        "code": false,
                        "color": "default"
                    },
                    "plain_text": "Some think chief ethics officers could help technology companies navigate political and social questions.",
                    "href": null
                }
            ]
        }
    }
}
    ''');
  }
}

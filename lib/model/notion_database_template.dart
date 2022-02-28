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
}

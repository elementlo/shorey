///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/2/24
/// Description:
///

class NotionDatabaseTemplate {
  static dynamic taskList(int pageId) {
    return '''
{
  "parent": {
    "type": "page_id",
    "page_id": "{${pageId}}"
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
    "Description": {
      "rich_text": {}
    },
    "Duration": {
      "date": {}
    },
    "Status": {
      "type": "select",
      "multi_select": {
        "options": [
          {
            "name": "On Going",
            "color": "blue"
          },
          {
            "name": "Achieved",
            "color": "green"
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
	"Links":{
		"type": "url"
	}
  }
}
    ''';
  }
}

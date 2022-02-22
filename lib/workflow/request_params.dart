///
/// Author: Elemen
/// Github: https://github.com/elementlo
/// Date: 2022/2/21
/// Description: 
///

class NotionParams {
  static String createDatabase(String pageId, String title){
    return '''
{
    \"parent\": {
        \"type\": \"page_id\",
        \"page_id\": \"${pageId}\"
    },
    \"title\": [
        {
            \"type\": \"text\",
            \"text\": {
                \"content\": \"${title}\",
                \"link\": null
            }
        }
    ],
    \"properties\": {
        \"Title\": {
            \"title\": {}
        },
        \"Duration\": {
            \"date\": {}
        }
    }
}
''';
  }
}

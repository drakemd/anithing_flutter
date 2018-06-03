import 'package:anithing/res/strings.dart';

Uri buildUrl(String sortBy, String pageLimit, String pageOffset, bool current, String search){
  String qparams;

  if(search != null){
    String searchFilterKey = Uri.encodeQueryComponent('filter[text]');
    qparams = "$qparams&$searchFilterKey=$search";
  }else{
    qparams = "sort=$sortBy";
  }
  if(pageLimit != null){
    String pageLimitKey = Uri.encodeQueryComponent('page[limit]');
    qparams = "$qparams&$pageLimitKey=$pageLimit";
  }
  if(pageOffset != null){
    String pageOffsetKey = Uri.encodeQueryComponent('page[offset]');
    qparams = "$qparams&$pageOffsetKey=$pageOffset";
  }
  if(current){
    String currentFilterKey = Uri.encodeQueryComponent('filter[status]');
    qparams = "$qparams&$currentFilterKey=current";
  }

  qparams = "$qparams&include=genres";

  Uri url = Uri.parse(Strings.basicUrl).replace(query: qparams);

  print("xxx " + url.toString());

  return url;
}
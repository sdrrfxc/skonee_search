
class Result {
  late String url;
  late String title;
  late String description;
  late String pageAge;
  late bool familyFriendly;
  late String image;


  Result({
    required String url,
    required String title,
    required String description,
    required String pageAge,
    required bool familyFriendly,
    required String image,
  });

  Result.parse(Map<String, dynamic> result) {
    print(result);
    url = result['url'].toString();
    title = result['title'].toString();
    description = result['description'].toString();
    pageAge = result['page_age'].toString();
    familyFriendly = result['family_friendly'];
    final profile = result['profile'];
    image = profile['img'];
  }

}

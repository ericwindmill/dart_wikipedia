import 'package:web/web.dart' as web;
import 'package:wikipedia/wikipedia.dart';

void main() {
  final searchBar =
      web.document.querySelector('#searchBar') as web.HTMLInputElement;
  final submitButton = web.document.querySelector('#submit')!;
  submitButton.onClick.listen((web.MouseEvent event) async {
    Summary summary = await getArticleSummaryByTitle(searchBar.value);
    print(summary.titles.normalized);
    final element = web.document.querySelector('#output') as web.HTMLDivElement;
    element.text = summary.titles.normalized;
  });
}

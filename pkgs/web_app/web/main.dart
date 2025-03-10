import 'package:web/web.dart' as web;
import 'package:web_app/web_app.dart';
import 'package:wikipedia/wikipedia.dart';

void main() {
  final submitButton = web.document.querySelector('#submit')!;
  submitButton.onClick.listen((web.MouseEvent event) => onClickButton());
}

web.HTMLDivElement newDiv(String titleText) {
  return (web.document.createElement('div') as web.HTMLDivElement)
    ..text = titleText;
}

void onClickButton() async {
  final searchBar =
      web.document.querySelector('#searchBar') as web.HTMLInputElement;
  Summary summary = await getArticleSummary(searchBar.value);
  final outputDiv = web.document.querySelector('#output') as web.HTMLDivElement;

  // Wikipedia API returns HTML, so we only need to use DIV elements
  outputDiv.appendChild(newDiv(summary.titles.display));
  outputDiv.appendChild(newDiv(summary.extractHtml));
}

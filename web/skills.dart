import 'dart:html';
import 'dart:convert';
import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_input.dart';
export 'package:polymer/init.dart';

var data;
const int animationTime = 5;

void filterHandler(var e) {
  PaperInput a = querySelector("#skillFilter");
  showSkills(a.inputValue);
}

void main() {
  initPolymer().run(() {
    Polymer.onReady.then((_) {
      HttpRequest.getString("data.json").then((String fileContents) {
        data = JSON.decode(fileContents);
        showSkills("");
      }).catchError((Error error) {
        print(error.toString());
      });

      querySelector("#skillFilter").onInput.listen((event) => filterHandler(event));
    });
  });
}

int compareSkills(var x, var y) {
  int ix = x["knowledge"];
  int iy = y["knowledge"];
  
  return -ix.compareTo(iy);
}

void showSkills(String filt) {
  var skills = querySelector("#skills");
  //clear elements
  skills.text = "";

  int cnt = 0;

  data.sort((x, y) => compareSkills(x, y));
      

  for (var e in data) {
    var tagContains = false;

    for (var t in e["tags"]) {
      if (t.toString().toLowerCase().contains(filt.toLowerCase())) {
        tagContains = true;
        break;
      }
    }

    if (e["name"].toLowerCase().contains(filt.toLowerCase()) || tagContains) {
      Element container = new Element.tag('div')..attributes = {
            "class": "col-xs-6"
          };
      
      Element skill = new Element.tag('div')..attributes = {
            "class": "skill"
          };
      
      Element name = new Element.tag('h2')
          ..text = e["name"].toString()
          ..attributes = {
            "class": "name"
          };
      skill.append(name);

      Element slider = new Element.tag('paper-progress')..attributes = {
            "value": "0",
            "data-value": e["knowledge"].toString()
          };
      skill.append(slider);

      var future = new Future.delayed(const Duration(milliseconds: animationTime), animateProgress);

      Element tags = new Element.tag('div');
      for (var t in e["tags"]) {
        Element tag = new Element.tag('span')
            ..text = t.toString()
            ..attributes = {
              "class": "tag"
            };
        tags.append(tag);
      }
      skill.append(tags);

      container.append(skill);
      skills.append(container);
      cnt++;
    }
  }

  if (cnt == 0) {
    skills.text = "Sorry I dont know that yet.";
  }
}

void animateProgress() {
  var progress = querySelectorAll("paper-progress");

  var cont = false;

  for (var prog in progress) {
    int val = int.parse(prog.attributes["value"]);
    int limit = int.parse(prog.attributes["data-value"]);

    if (limit > val) {
      prog.attributes = {
        "value": (val + 1).toString(),
        "data-value": limit.toString()
      };
    }

    if (limit > val) cont = true;
  }

  if (cont) var future = new Future.delayed(const Duration(milliseconds: animationTime), animateProgress);
}

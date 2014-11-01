import 'dart:html';
import 'dart:convert';
import 'dart:async';

var data;
const int animationTime = 12;

void filterHandler(var e) {
  //print("called");
  //print(e);
  var a = querySelector("#skillFilter").value();
    print(a);

  
  //var filt = querySelector("#skillFilter")
  //    ..oninput.listen(showSkills("g"));
}

void main() {  
  HttpRequest.getString("data.json")
        .then((String fileContents) {
      data = JSON.decode(fileContents); 
      showSkills("");
  })
    .catchError((Error error) {
      print(error.toString());
    });
  
  querySelector("#skillFilter").onInput.listen(
      (event) => filterHandler(event));
}



void showSkills(String filt) {
  
  
  
  var skills = querySelector("#skills");

  
//clear elements
skills..text = "";

int cnt = 0;

//List<Element> container = new List<Element>();

  for(var e in data) {
    if (e["name"].contains(filt)) {
    
      //print(e["name"]);
    //printElement);
    //skills..text = element[key];
    
    Element container =  new  Element.tag('div');
    
    Element name =  new  Element.tag('h2')
      ..text = e["name"].toString()
      ..attributes = {"class": "name"};
    container.append(name);
    
    //print("tags");
    
    Element tags =  new  Element.tag('div');
    for(var t in e["tags"]) {
      Element tag =  new  Element.tag('span')
        ..text = t.toString()
        ..attributes = {"class": "tag"};
      tags.append(tag);
    }
    container.append(tags);
    
    
    
    /*function nextProgress() {
         animating = true;
         if (progress.value < progress.max) {
           progress.value += (progress.step || 1);
         } else {
           if (++repeat >= maxRepeat) {
             animating = false;
             button.disabled = false;
             return;
           }
           progress.value = progress.min;
         }
         progress.async(nextProgress);
       }
       
       function startProgress() {
         repeat = 0;
         progress.value = progress.min;
         button.disabled = true;
         if (!animating) {
           nextProgress();
         }
       }
       * */
        
    
    //print(e["knowledge"]);
    
    
    Element slider =  new  Element.tag('paper-progress')
      ..attributes = {
        "value": "0",
        "data-value": e["knowledge"].toString()
                      
    };
    container.append(slider);
    
    var future = new Future.delayed(const Duration(milliseconds: animationTime), animateProgress);
              
    //container.add(cont);
    
    //print("final");

    skills.append(container);
    cnt++;
    }
  }
  
  if (cnt == 0) {
    skills..text = "Sorry I dont know that yet.";
  }
  
  

}

void animateProgress() {
  var progress = querySelectorAll("paper-progress");
  
  var cont = false;
  
  for(var prog in progress) {
    
    //print(int.parse(prog.attributes["data-value"]) > int.parse(prog.attributes["value"]));
    int val = int.parse(prog.attributes["value"]);
    int limit = int.parse(prog.attributes["data-value"]);
    
    if(limit > val) {
      //print((val+1).toString());
      prog.attributes = {
         "value": (val+1).toString(),
         "data-value": limit.toString()
         };
      //print(prog.attributes["data-value"] + " " + prog.attributes["value"]);
    }
    
    if(limit > val)
      cont = true;
  }
  
  if(cont)
    var future = new Future.delayed(const Duration(milliseconds: animationTime), animateProgress);
}



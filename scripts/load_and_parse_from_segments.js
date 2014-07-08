var jQuery = require('jQuery');
print("hello world!");
var data = jQuery.parseJSON("./audio/test.json");

/*
$.getJSON('./audio/test.json', function(data) {
        var output="<ul>";
        for (var i in data.users) {
            output+="<li>" + data.users[i].firstName + " " + data.users[i].lastName + "--" + data.users[i].joined.month+"</li>";
        }

        output+="</ul>";
        document.getElementById("placeholder").innerHTML=output;
  });
*/


var start_reloader = function(name) {
    var http_request = new XMLHttpRequest();
    http_request.onreadystatechange = function(){
	alert(http_request.responseText);
    };
    http_request.open("GET", "/" + name, false);
    http_request.send();
};

var setup_some_stuff = function() {
    start_reloader('edsbergsskolan');
    alert("reloader started");
};

window.onload = setup_some_stuff;

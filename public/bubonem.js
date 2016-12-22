
var wave_the_staff = function(widget) {
    return function() {
        var timeout_minutes = $(widget).attr("data-timeout");
        var timeout_millis = parseInt( timeout_minutes ) * 60 * 1000;
        content_magic(widget);
        window.setTimeout( wave_the_staff(widget), timeout_millis );
    };
}

var content_magic = function(widget) {
    var url = $(widget).attr('data-url');
    $.get(url, function(response) {
        $(widget).html(response);
    });
};

$(function() {
    // the function needs to be inside a funcition in order to get hold of this
    $(".widget").each(function(index) { wave_the_staff(this)() });
});


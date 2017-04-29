
var timeout_in_millis_for = function(widget) {
    var timeout_minutes = $(widget).attr("data-timeout");
    return parseInt( timeout_minutes ) * 60 * 1000;
};

var wave_the_staff = function(widget) {
    return function() {
        content_magic(widget);
        window.setTimeout( wave_the_staff(widget), timeout_in_millis_for(widget) );
    };
}

var content_magic = function(widget) {
    var url = $(widget).attr('data-url');
    $.get(url)
	.done( function(response) { $(widget).html(response) })
	.fail( function() { $(widget).html("Anropet misslyckades") } );
};

$(function() {
    // for every 'widget' - wave the staff to get content into it.
    // The function needs to be inside a function in order to get hold of this.
    $(".widget").each(function(index) { wave_the_staff(this)() });
});


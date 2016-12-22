
var old_wave_the_staff = function(name) {
    return function() {
        var timeout_minutes = $('.' + name).attr('data-timeout');
        var timeout_millis = parseInt( timeout_minutes ) * 60 * 1000;
        old_content_magic(name);
        window.setTimeout( old_wave_the_staff(name), timeout_millis );
    };
}

var wave_the_staff = function() {
    console.log("waving the staff");
    return function() {
        var timeout_minutes = $(this).attr('data-timeout');
        var timeout_millis = parseInt( timeout_minutes ) * 60 * 1000;
        content_magic(this);
        window.setTimeout( wave_the_staff(), timeout_millis );
    };
}

var old_content_magic = function(name) {
    $.get('/' + name, function(response) {
        $('.' + name).html(response);
    });
};

var content_magic = function(widget) {
    var url = $(widget).attr('data-url');
    $.get(url, function(response) {
        $(widget).html(response);
    });
};

$(function() {
    let parts = ['edsbergsskolan', 'axroad', 'weather_forecast', 'current_time'];
    for(let one_part of parts) {
        old_wave_the_staff(one_part)();
    };

    $(".widget").each(wave_the_staff(this));
});


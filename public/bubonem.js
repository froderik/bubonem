
var wave_the_staff = function(name) {
    return function() {
        var timeout_minutes = $('.' + name).attr('data-timeout');
        var timeout_millis = parseInt( timeout_minutes ) * 60 * 1000;
        content_magic(name);
        window.setTimeout( wave_the_staff(name), timeout_millis );
    };
}

var content_magic = function(name) {
    $.get('/' + name, function(response) {
        $('.' + name).html(response);
    });
};

$(function() {
    let parts = ['edsbergsskolan', 'axroad', 'weather_forecast', 'current_time', 'sun'];
    for(let one_part of parts) {
        wave_the_staff(one_part)();
    };
});



var wave_the_staff = function(name) {
    return function() {
        content_magic(name);
    };
}

var content_magic = function(name) {
    $.get('/' + name, function(response) {
        $('.' + name).html(response);
    });
};

$(function() {
    let parts = ['edsbergsskolan', 'axroad', 'weather_forecast', 'current_time'];
    for(let one_part of parts) {
        var timeout_minutes = $('.' + one_part).attr('data-timeout');
        var timeout_millis = parseInt( timeout_minutes ) * 60 * 1000;
        var staff_of_content = wave_the_staff(one_part);
        staff_of_content();
        window.setTimeout( staff_of_content, timeout_millis );
    };
});


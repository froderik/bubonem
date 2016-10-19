
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
    let parts = ['edsbergsskolan', 'axroad', 'weather_forecast'];
    for(let one_part of parts) {
        var staff_of_content = wave_the_staff(one_part);
        staff_of_content();
        window.setTimeout( staff_of_content, 1000 );
    };
});


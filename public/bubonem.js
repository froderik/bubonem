

var content_magic = function(name) {
    $.get('/' + name, function(response) {
        $('.' + name).html(response);
    });
};

$(function() {
    let parts = ['edsbergsskolan', 'axroad', 'weather_forecast'];
    for(let one_part of parts) {
        content_magic(one_part);
    };
});


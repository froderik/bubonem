

var content_magic = function(name) {
    $.get('/' + name, function(response) {
	$('.' + name).text(response);
    });
};

$(function() {
    let parts = ['edsbergsskolan', 'axroad'];
    for(let one_part of parts) {
	content_magic(one_part);
    };
});


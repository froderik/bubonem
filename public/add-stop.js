
var show_stop_picker = function() {
    $(".stop-picker").show();
};

var hide_stop_picker = function() {
    $(".stop-picker").hide();
};

$(function() {
    $(".add-stop").click(show_stop_picker);
    $(".stop-picker .close").click(hide_stop_picker);
});

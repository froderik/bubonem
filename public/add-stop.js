

var search_for_stop = function() {
    var q = $(".stop-search").val();

    console.log("yo " + q);
};


var show_stop_picker = function() {
    $(".stop-picker").show();
};

var hide_stop_picker = function() {
    $(".stop-picker").hide();
};

$(function() {
    $(".add-stop").click(show_stop_picker);
    $(".stop-picker .close").click(hide_stop_picker);
    $(".stop-search").on("input", search_for_stop);
});

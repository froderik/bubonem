
var select_stop = function( event ) {
    var stop_name = $(this).text();
    var stop_id = $(this).attr( "data-stop-id" );

    var stop_markup = "<li data-stop-id=\"" + stop_id + "\">" + stop_name + "</li>";
    
    $("#selected-stops-list").append(stop_markup);
    hide_stop_picker();
};

var show_search_result = function( data ) {
    $("#stop-list").html( data );
    $(".one-stop-to-select").click( select_stop );
};

var search_for_stop = function() {
    var q = $(".stop-search").val();
    if(q.length >= 3) {
        $.get( "stations/" + q, show_search_result);
    } else {
        $( "#stop-list" ).html( "" );
    }
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

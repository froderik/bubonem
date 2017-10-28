
var select_stop = function( event ) {
    var stop_name = $(this).text();
    var stop_id = $(this).attr( "data-stop-id" );

    var stop_markup = "<li class=\"selected-stop\"  data-stop-id=\"" + stop_id + "\">"
        + '<span class=\"stop-name\">' + stop_name + '</span>'
        + '<select class=\"stop-type-select\">'
        + '<option value="bus" selected>Buss</option>'
        + '<option value="tub">T-bana</option>'
        + '<option value="tram">Spårvagn</option>'
        + '<option value="train">Pendeltåg</option>'
        + '</select>'
        + "</li>";
    
    $("#selected-stops-list").append(stop_markup);
    hide_stop_picker();
    clear_search_field();
    calculate_link();
    $(".stop-type-select").change(calculate_link);
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
    $(".stop-search").focus();
};

var hide_stop_picker = function() {
    $(".stop-picker").hide();
};

var clear_search_field = function() {
    $(".stop-search").val("");
};

var close_if_escaping = function(e) {
    if( e.keyCode == 27 ) {
	hide_stop_picker();
    }
};

$(function() {
    $(".add-stop").click(show_stop_picker);
    $(".stop-picker .close").click(hide_stop_picker);
    $(".stop-search").on("input", search_for_stop);
    $(document).keyup(close_if_escaping)
});

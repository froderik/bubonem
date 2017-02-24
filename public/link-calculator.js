
var grab_stop_information = function() {
    var stops_ary = []
    $(".selected-stop").each(function() {
        var stop_id = $(this).attr( "data-stop-id" );
        var this_part = stop_id + ":bus";
        stops_ary.push(this_part);
    });

    if( stops_ary.length > 0 ) {
        return "stops=" + stops_ary.join();
    } else {
        return "";
    }
};

var push_unless_empty = function(ary, part) {
    if( part != "" ) {
        ary.push(part);
    }
};

var calculate_link = function() {
    var url = "/dash?";

    var params_parts = [];

    push_unless_empty( grab_stop_information() );

    var all_params = params_parts.join("&");

    url += all_params;

    $(".my-link").text( url );
    $(".my-link").attr( "href", url );
};

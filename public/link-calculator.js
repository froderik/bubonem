
var grab_stop_information = function() {
    var stops_ary = []
    $(".selected-stop").each(function() {
        var stop_id = $(this).attr( "data-stop-id" );
        var stop_type = $(this).find(".stop-type-select").val();
        var this_part = stop_id + ":" + stop_type;
        stops_ary.push(this_part);
    });

    if( stops_ary.length > 0 ) {
        return "stops=" + stops_ary.join();
    } else {
        return "";
    }
};

var grab_map_information = function(name) {
    var value = $("#" + name).val();

    if( value === "" ) {
        return "";
    }
    return name + "=" + value;
};


var push_unless_empty = function(ary, part) {
    if( part != "" ) {
        ary.push(part);
    }
};

var calculate_link = function() {
    var url = "/dash?";

    var params_parts = [];

    push_unless_empty( params_parts, grab_stop_information() );
    push_unless_empty( params_parts, grab_map_information("lat") );
    push_unless_empty( params_parts, grab_map_information("lon") );

    var all_params = params_parts.join("&");

    url += all_params;

    $(".my-link").text( url );
    $(".my-link").attr( "href", url );
};

$(function() {
    $(".link-source").keyup(calculate_link);
    $(".link-source").change(calculate_link);
});


var calculate_link = function() {
    var url = "/dash?";

    var stops_ary = []
    $(".selected-stop").each(function() {
        var stop_id = $(this).attr( "data-stop-id" );
        var this_part = stop_id + ":bus";
        stops_ary.push(this_part);
    });

    if( stops_ary.length > 0 ) {
        url += "stops=" + stops_ary.join();
    }

    $(".my-link").text( url );
    $(".my-link").attr( "href", url );
};

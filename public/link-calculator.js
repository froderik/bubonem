
let grab_stop_information = () => {
    let stops_ary = []

    let stops_list = many(".selected-stop")
    for(stop of stops_list) {
        let stop_id = stop.attributes['data-stop-id'].value
        stops_ary.push(stop_id);
    }

    if( stops_ary.length > 0 ) {
        return "stops=" + stops_ary.join();
    } else {
        return "";
    }
};

let grab_location_information = (name) => {
    let value = one("#" + name).value

    if( value === "" ) {
        return "";
    }
    return name + "=" + value;
};


let push_unless_empty = (ary, part) => {
    if( part != "" ) {
        ary.push(part);
    }
};

let calculate_link = () => {
    let url = "/dash?";

    let params_parts = [];

    push_unless_empty( params_parts, grab_stop_information() );
    push_unless_empty( params_parts, grab_location_information("lat") );
    push_unless_empty( params_parts, grab_location_information("lon") );

    let all_params = params_parts.join("&");

    url += all_params;

    da_link = one(".my-link")
    da_link.innerHTML = url
    da_link.href = url
};

im_ready( (e) => {
    add_event(".link-source", "keyup", calculate_link)
    add_event(".link-source", "change", calculate_link)
});

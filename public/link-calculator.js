
let grab_stop_information = () => {
    let stops_ary = []

    let stops_list = document.querySelectorAll(".selected-stop")
    for(stop of stops_list) {
        let stop_id = stop.attributes['data-stop-id'].value
        let stop_type = stop.querySelector(".stop-type-select").value
        let this_part = stop_id + ":" + stop_type;
        stops_ary.push(this_part);
    }

    if( stops_ary.length > 0 ) {
        return "stops=" + stops_ary.join();
    } else {
        return "";
    }
};

let grab_location_information = (name) => {
    let value = document.querySelector("#" + name).value

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

    da_link = document.querySelector(".my-link")
    da_link.innerHTML = url
    da_link.href = url
};

let add_event = (css_selector, event_name) => {
    for(node of document.querySelectorAll(css_selector)) {
        node.addEventListener(event_name, calculate_link);
    }
}

window.addEventListener('DOMContentLoaded', (e) => {
    add_event(".link-source", "keyup")
    add_event(".link-source", "change")
});

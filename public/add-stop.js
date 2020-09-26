
let update_selected_stops_list = (stop_id, stop_name) => {
    let stop_markup = "<li class=\"selected-stop\"  data-stop-id=\"" + stop_id + "\">"
        + '<span class=\"stop-name\">' + stop_name + '</span>'
        + "</li>";

    let selected_stops_list = one('#selected-stops-list')
    selected_stops_list.insertAdjacentHTML('beforeend', stop_markup)
}

let select_stop = (event) => {
    let stop_name = event.srcElement.text
    let stop_id = event.srcElement.attributes['data-stop-id'].value

    update_selected_stops_list(stop_id, stop_name)
    hide_stop_picker();
    clear_search_field();
    calculate_link();
    add_event('.stop-type-select', 'change', calculate_link)
}

let show_search_result = (data) => {
    one('#stop-list').innerHTML = data
    add_event('.one-stop-to-select', 'click', select_stop)
}

let search_for_stop = () => {
    let q = one('.stop-search').value;
    if(q.length >= 3) {
        let client = new XMLHttpRequest()
        client.open("GET", `stations/${q}`)
        client.addEventListener('load', (e) => show_search_result(e.srcElement.responseText))
        client.send()
    } else {
        one('#stop-list').innerHTML = ''
    }
}

let show_stop_picker = () => {
    let stop_picker = one('.stop-picker')
    show(stop_picker)

    one('.stop-search').focus()
}

let hide_stop_picker = () => {
    let stop_picker = one('.stop-picker')
    hide(stop_picker)
}

let clear_search_field = () => {
    one('.stop-search').value = ""
}

let close_if_escaping = (e) => {
    let escapeKeyCode = 27
    if( e.keyCode == escapeKeyCode ) {
        hide_stop_picker()
    }
}

im_ready( (e) => {
    add_event('.add-stop', 'click', show_stop_picker)
    add_event('.stop-picker .close', 'click', hide_stop_picker)
    add_event('.stop-search', 'input', search_for_stop)
    document.addEventListener('keyup', close_if_escaping)
})

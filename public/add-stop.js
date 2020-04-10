
let update_selected_stops_list = (stop_id, stop_name) => {
    let stop_markup = "<li class=\"selected-stop\"  data-stop-id=\"" + stop_id + "\">"
        + '<span class=\"stop-name\">' + stop_name + '</span>'
        + '<select class=\"stop-type-select\">'
        + '<option value="bus" selected>Buss</option>'
        + '<option value="tub">T-bana</option>'
        + '<option value="tram">Spårvagn</option>'
        + '<option value="train">Pendeltåg</option>'
        + '</select>'
        + "</li>";

    let selected_stops_list = document.querySelector('#selected-stops-list')
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
    document.querySelector('#stop-list').innerHTML = data
    add_event('.one-stop-to-select', 'click', select_stop)
}

let search_for_stop = () => {
    let q = document.querySelector('.stop-search').value;
    if(q.length >= 3) {
        let client = new XMLHttpRequest()
        client.open("GET", `stations/${q}`)
        client.addEventListener('load', (e) => show_search_result(e.srcElement.responseText))
        client.send()
    } else {
        document.querySelector('#stop-list').innerHTML = ''
    }
}

let show_stop_picker = () => {
    let stop_picker = document.querySelector('.stop-picker')
    show(stop_picker)

    document.querySelector('.stop-search').focus()
}

let hide_stop_picker = () => {
    let stop_picker = document.querySelector('.stop-picker')
    hide(stop_picker)
}

let clear_search_field = () => {
    document.querySelector('.stop-search').value = ""
}

let close_if_escaping = (e) => {
    let escapeKeyCode = 27
    if( e.keyCode == escapeKeyCode ) {
        hide_stop_picker()
    }
}


window.addEventListener('DOMContentLoaded', (e) => {
    add_event('.add-stop', 'click', show_stop_picker)
    add_event('.stop-picker .close', 'click', hide_stop_picker)
    add_event('.stop-search', 'input', search_for_stop)
    document.addEventListener('keyup', close_if_escaping)
})

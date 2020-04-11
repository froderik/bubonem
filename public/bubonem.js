// NEW "FRAMEWORK"

let add_event = (css_selector, event_name, fn) => {
    for(node of document.querySelectorAll(css_selector)) {
        node.addEventListener(event_name, fn);
    }
}

let show = (el) => {
    el.style.display = 'block'
}

let hide = (el) => {
    el.style.display = 'none'
}

let im_ready = (fn) => {
    window.addEventListener('DOMContentLoaded', fn)
}




// the main stuff to update the actual dashboard

let timeout_in_millis_for = (widget) => {
    let timeout_minutes = widget.attributes['data-timeout'].value
    return parseInt( timeout_minutes ) * 60 * 1000;
};

let wave_the_staff = (widget) => {
    return () => {
        content_magic(widget);
        window.setTimeout( wave_the_staff(widget), timeout_in_millis_for(widget) );
    };
}

let content_magic = (widget) => {
    let url = widget.attributes['data-url'].value

    let client = new XMLHttpRequest()
    client.open("GET", url)
    client.addEventListener("load", (e) => { widget.innerHTML = e.srcElement.responseText })
    client.addEventListener("abort", () => { widget.innerHTML = "Anropet avbröts" })
    client.addEventListener("error", () => { widget.innerHTML = "Anropet misslyckades" })

    client.send()
};


im_ready( (e) => {
    // for every 'widget' - wave the staff to get content into it.
    // The function needs to be inside a function in order to get hold of this.
    let widgets = document.querySelectorAll(".widget")
    for( w of widgets ) { wave_the_staff(w)() }
})


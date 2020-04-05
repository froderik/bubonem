
let timeout_in_millis_for = (widget) => {
    let timeout_minutes = $(widget).attr("data-timeout");
    return parseInt( timeout_minutes ) * 60 * 1000;
};

let wave_the_staff = (widget) => {
    return () => {
        content_magic(widget);
        window.setTimeout( wave_the_staff(widget), timeout_in_millis_for(widget) );
    };
}

let content_magic = (widget) => {
    let url = $(widget).attr('data-url');
    $.get(url)
	.done( (response) => { $(widget).html(response) })
	.fail( () => { $(widget).html("Anropet misslyckades") } );
};

$(() => {
    // for every 'widget' - wave the staff to get content into it.
    // The function needs to be inside a function in order to get hold of this.
    $(".widget").each(function(index) { wave_the_staff(this)() });
});


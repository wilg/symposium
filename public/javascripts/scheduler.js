function show_edit_panel(content_url) {
	new Ajax.Updater("edit_options", content_url, {
	  onComplete: edit_panel_loaded
	});
}

function edit_panel_loaded(request) {
	$("edit_section_envelope").show();
}

function hide_edit_panel() {
	$("edit_section_envelope").hide();
}


function show_saving_box() {
	hide_edit_panel();
	$("saving").show();
}

function hide_saving_box() {
	$("saving").hide();
}

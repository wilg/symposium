var pickable_lectures = 3;

function set_pickable_lectures(x) {
	pickable_lectures = x;
}

function click_header(lecture_id) {

	var checkbox = $("checkbox_" + lecture_id);
	
	if (checkbox.checked)
		checkbox.checked = false;
	else
		checkbox.checked = true;
	
	checked_classes(lecture_id);
	count_checkboxes();
}

function checkbox_clicked(lecture_id) {
	checked_classes(lecture_id);
	count_checkboxes();
	return false;
}

function checked_classes(lecture_id) {
	if ($("checkbox_" + lecture_id).checked)
		$("lecture_info_" + lecture_id).addClassName("checked");
	else
		$("lecture_info_" + lecture_id).removeClassName("checked");
}

function count_checkboxes() {
	var selected_sessions = $$(".checked").size();
	if (selected_sessions > pickable_lectures) {
		$("submit_button").hide();
		$("submit_error").show().innerHTML = "You've selected too many breakout sessions!";
	}
	else if (selected_sessions == 0) {
		$("submit_button").hide();
		$("submit_error").show().innerHTML = "You can't continue until you've chosen some breakout sessions.";
	}
	else if (selected_sessions < pickable_lectures) {
		$("submit_button").hide();
		$("submit_error").show().innerHTML = "You have to pick " + pickable_lectures +" breakout sessions!";
	}
	if (selected_sessions == pickable_lectures) {
		$("submit_button").show();
		$("submit_error").hide();
	}
	
}
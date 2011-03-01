function order_submit() {
	var list = $('sortable_list');
	list.childElements().each(function(element, index) {
	  $(element.id + "_field").value = index + 1;
	});
	return true;
}
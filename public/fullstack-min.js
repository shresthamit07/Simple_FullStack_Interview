$(document).ready(function() {
	$("#user_info_table th:first").addClass("highlight");

    var uTable = $('#user_info_table').DataTable({
    	"paging":   false,
        "info":     false,
        "searching": false,
    	"order": [[ 0, "asc" ]],
    	"columnDefs": [
    	{"orderData":[ 5 ],   "targets": [ 4 ]},
            {
                "targets": [ 5 ],
                "visible": false,
                "searchable": false,
                "bSortable": true,
                'sType': 'number'
            }],
    	"fnRowCallback": function() {
    		$("#user_info_table th:first").addClass("highlight");
    	}
    });
    uTable.state.clear();

    $("input[name='file_upload']").change(function() { this.form.submit(); uTable.fnDraw();});

     $('#user_info_table')
        .on( 'click', 'th', function () {
            $(this).closest('th').addClass('highlight');
            $("#user_info_table th").not(this).removeClass("highlight");
        } );

} );
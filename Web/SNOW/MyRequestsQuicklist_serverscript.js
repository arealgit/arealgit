(function() {
	data.sysID = gs.getUserID();
	var alsoRequest = false;

	var localInput = input; //to safeguard pollution of 'input' via BR or other scripts

	data.filterMsg = gs.getMessage("Search open requests");

	if (localInput && localInput.view === 'open')
		data.filterMsg = gs.getMessage("Search open requests");
	else if (localInput && localInput.view === 'close')
		data.filterMsg = gs.getMessage("Search closed requests");

	function getField(gr, name) {
		var f = {};
		var id = gr.getUniqueValue();
		gr = new GlideRecord(gr.getRecordClassName());
		gr.get(id);
		f.display_value = gr.getDisplayValue(name);
		f.value = gr.getValue(name);
		var ge = gr.getElement(name);
		if (ge) {
			var ed = ge.getED();
			if (ed)
				f.type = ed.getInternalType();
			f.label = ge.getLabel();
		}
		return f;
	}

	function getMyRequestSysIds() {
		var ids = {};
		var rq_filter = new GlideRecord('request_filter');
		rq_filter.addActiveQuery();
		rq_filter.addQuery('table','sc_request')
		if (rq_filter.isValidField('applies_to'))
			rq_filter.addQuery('applies_to', 1).addOrCondition('applies_to', 10);
		rq_filter.query();
		while(rq_filter.next()) {
			var tableName = rq_filter.table_name;
			if (rq_filter.isValidField('table'))
				tableName = rq_filter.table;
			var gr = new GlideRecord(tableName);

			gr.addQuery(rq_filter.filter);
			gr.query();
			if (tableName == 'sc_request')
				alsoRequest = true;
			if (tableName == 'incident')
				continue;
			while(gr.next()) {
				var portalSettings = {};
				portalSettings.page = rq_filter.portal_page.nil()? '' : rq_filter.portal_page.getDisplayValue() + '';
				portalSettings.primary_display = rq_filter.primary_display.nil()? '': rq_filter.primary_display + '';
				portalSettings.secondary_displays = rq_filter.secondary_display.nil()? '': rq_filter.secondary_display + '';
				ids[gr.sys_id + ''] = portalSettings;
			}
		}
		return ids;
	}

	// retrieve the request's
	var myRequestMap = getMyRequestSysIds();
	var taskIDs = Object.keys(myRequestMap);

	var gr = new GlideRecordSecure('task');
	if (localInput && localInput.view === 'open') 
		gr.addActiveQuery();
	else if (localInput && localInput.view === 'close')
		gr.addQuery('active', 0);
	else
		gr.addActiveQuery();

	gr.orderByDesc('sys_created_on');
	if (localInput && localInput.search_text) {
		var req = [];
		var task = new GlideRecordSecure('task');
		task.addQuery('123TEXTQUERY321', localInput.search_text);
		if (localInput && localInput.view === 'open') 
			task.addQuery('active', 1);
		else if (localInput && localInput.view === 'close')
			task.addQuery('active', 0);
		else
			task.addQuery('active', 1);
		task.addQuery('sys_id', taskIDs);
		task.query();

		while(task.next())
			req.push(task.getUniqueValue());

		if (alsoRequest) {
			var ritmGR = new GlideRecord('sc_req_item');
			if (localInput && localInput.view === 'open') 
				ritmGR.addQuery('request.active', 1);
			else if (localInput && localInput.view === 'close')
				ritmGR.addQuery('request.active', 0);
			else
				ritmGR.addQuery('request.active', 1);
			ritmGR.addQuery('123TEXTQUERY321', localInput.search_text);
			ritmGR.addQuery('request.sys_id', taskIDs);
			ritmGR.query();
			while(ritmGR.next())
				req.push(ritmGR.getValue('request'));
		}
		gr.addQuery('sys_id', req);
	}
	else 
		gr.addQuery('sys_id', taskIDs);
	gr.query();

	data.request = {};

	data.request.req_list = [];
	var recordIdx = 0;	
	var limit = options.items_per_page? options.items_per_page : 15;
	if (localInput && localInput.action == 'fetch_more')
		data.lastLimit = localInput.lastLimit + limit;
	else
		data.lastLimit = limit;

	data.hasMore = false;
	//while (recordIdx != data.lastLimit && gr.next()) {
	while (gr.next()) {
	
		var portalSettings = myRequestMap[gr.getUniqueValue()];
		if (typeof portalSettings == 'undefined')
			portalSettings = {};

		var record = {};
		record.sys_id = gr.getValue('sys_id');

		if (gr.getRecordClassName() == 'sc_request') {
			var ritm = new GlideRecord("sc_req_item");
			ritm.addQuery("request", gr.getUniqueValue());
			ritm.query();
			if (ritm.getRowCount() == 0)
				continue;



			if (ritm.getRowCount() > 1) {
				record.multiItem = true;
				record.display_field = [];
				while (ritm.next()) {
					var itemObj = {title: ritm.cat_item.getDisplayValue(),
												 number: ritm.getDisplayValue("number")}
					record.display_field.push(itemObj);
				}

			}
			else {
				ritm.next();
				record.display_field = {title: ritm.cat_item.getDisplayValue() || ritm.getDisplayValue("short_description"),
																number: ritm.getDisplayValue("number")
															 };
			}
			record.url = { id: portalSettings.page? portalSettings.page: 'sc_request', table: 'sc_request', sys_id: record.sys_id};
		} else {
			record.display_field = portalSettings.primary_display ? getField(gr, portalSettings.primary_display).display_value : getField(gr, 'number').display_value;
			record.url = { id: portalSettings.page? portalSettings.page :'ticket', table: gr.getRecordClassName(), sys_id: record.sys_id};
		}
		if (portalSettings.secondary_displays) {
			record.secondary_displays = [];
			portalSettings.secondary_displays.split(",").forEach(function (sDisplay){
				record.secondary_displays.push(getField(gr, sDisplay));
			});
		}
		else 
			record.secondary_displays = getField(gr, 'short_description');

		record.updated_on = gr.getValue('sys_updated_on');
		record.created_on = gr.getValue('sys_created_on');
		record.state = gr.getDisplayValue('state');
		if((recordIdx !== 0) && (data.lastLimit - limit === recordIdx))
			record.highlight = true;

		data.request.req_list.push(record);
		recordIdx++;
	}

	if (gr.next())
		data.hasMore = true;


})();
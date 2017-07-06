window.addEventListener('load', function() {
	document.getElementById('urltag').innerHTML = document.location; // location.protocol + '//' + location.host; //
	[
		{id: 'pic',		tm: 1000},
		{id: 'urltag',	tm: 100},
		{id: 'reason',	tm: 500}
	].forEach(function(item) {
		setTimeout(
			function(){
				document.getElementById(item.id).classList.add('visible');
			},
			item.tm
		);
	});
});
$(function(){
	$('#focus ul')
		.after('<div class="focus_btn" />')
		.cycle({ 
			fx: 'fade',
			timeout: 4000,
			pause: 1 ,
			pager: '.focus_btn',
			pagerEvent: 'mouseover',
			pauseOnPagerHover: true,
			cleartype: !$.support.opacity,
			cleartypeNoBg: true,
			activePagerClass: 'active',
			pagerAnchorBuilder: function(idx, slide){
				idx += 1;
				return '<span>'+idx+'</span>'; 
			}
		});
});
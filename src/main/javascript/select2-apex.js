var beCtbSelect2 = {};

beCtbSelect2.events = {
  bind: function (pItem) {
    var pageItem = $("" + pItem + "");

    pageItem.on("change", function(e) {
      apex.jQuery(this).trigger("slctchange", {select2: e});
      if ($.fn.jquery !== apex.jQuery.fn.jquery) {
        apex.jQuery(this).trigger("change");
      }
    });
    pageItem.on("select2:close", function(e) {
      apex.jQuery(this).trigger("slctclose", {select2: e});
    });
    pageItem.on("select2:closing", function(e) {
      apex.jQuery(this).trigger("slctclosing", {select2: e});
    });
    pageItem.on("select2:open", function(e) {
      apex.jQuery(this).trigger("slctopen", {select2: e});
    });
    pageItem.on("select2:opening", function(e) {
      apex.jQuery(this).trigger("slctopening", {select2: e});
    });
    pageItem.on("select2:select", function(e) {
      apex.jQuery(this).trigger("slctselect", {select2: e});
    });
    pageItem.on("select2:selecting", function(e) {
      apex.jQuery(this).trigger("slctselecting", {select2: e});
    });
    pageItem.on("select2:unselect", function(e) {
      apex.jQuery(this).trigger("slctunselect", {select2: e});
    });
    pageItem.on("select2:unselecting", function(e) {
      apex.jQuery(this).trigger("slctunselecting", {select2: e});
    });
  }
};

beCtbSelect2.main = {
initSelect2 : function(pSelector,lAjaxIdentifier,isLazyLoading) {   
apex.jQuery(pSelector).each(function(index,element){
  var $select2Item = $(element);  
  var setVal = function(pValue, pDisplayValue) {       
     if (!pValue) {       
      $select2Item.val(null).trigger('change');
    } else {        
        if(isLazyLoading) {      
          apex.server.plugin(lAjaxIdentifier,{
            x04 : pValue,
            x06 : "GETDATA",
            dataType: "json"
          },{
              error: function( jqXHR,textStatus,errorThrown ) {
                console.log("Error");
                console.log(jqXHR);
                console.log(textStatus);
                console.log(errorThrown);
              }, 
              success: function(ajaxResult) {
                $select2Item.empty();
                ajaxResult.forEach(function(elt,index) {               
                  var option = new Option(elt.D,elt.R, true, true);
                  $select2Item.append(option);
                });
                $select2Item.trigger('change');
                // manually trigger the `select2:select` event
                $select2Item.trigger({
                  type: 'select2:select',
                  params: { data: ajaxResult}
                });                          
              } 
          }); 
      } else {
         select2Arr = [];
         inputDataArr = pValue.split(':'); 
         $select2Item.val(inputDataArr);       
      }
    }      
  }; 
  
  // disable auto open select list by removing an option  - select2 "bugfix"
  $select2Item.on('select2:unselecting', function() {
    var opts = $(this).data('select2').options;
    opts.set('disabled', true);
    setTimeout(function() {
        opts.set('disabled', false);
    }, 1);
  });    

  // Register apex.item callback
  apex.item.create($select2Item[0],{ setValue: setVal});
});
}
}
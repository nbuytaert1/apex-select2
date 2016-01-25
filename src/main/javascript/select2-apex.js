var beCtbSelect2 = {};

beCtbSelect2.events = {
  bind: function (pItem) {
    var pageItem = $("" + pItem + "");

    pageItem.on("change", function(e) {
      apex.jQuery(this).trigger("slctchange", {val:e.val, added:e.added, removed:e.removed});
      if ($.fn.jquery !== apex.jQuery.fn.jquery) {
        apex.jQuery(this).trigger("change");
      }
    });
    pageItem.on("select2-opening", function(e) {
      apex.jQuery(this).trigger("slctopening");
    });
    pageItem.on("select2-open", function(e) {
      apex.jQuery(this).trigger("slctopen");
    });
    pageItem.on("select2-highlight", function(e) {
      apex.jQuery(this).trigger("slcthighlight", {val:e.val, choice:e.choice});
    });
    pageItem.on("select2-selecting", function(e) {
      apex.jQuery(this).trigger("slctselecting", {val:e.val, choice:e.choice});
    });
    pageItem.on("select2-clearing", function(e) {
      apex.jQuery(this).trigger("slctclearing");
    });
    pageItem.on("select2-removed", function(e) {
      apex.jQuery(this).trigger("slctremoved", {val:e.val, choice:e.choice});
    });
    pageItem.on("select2-focus", function(e) {
      apex.jQuery(this).trigger("slctfocus");
    });
    pageItem.on("select2-blur", function(e) {
      apex.jQuery(this).trigger("slctblur");
      $(this).trigger("blur");
    });
  }
};

function info_oracleapex_text_field(pSelector,request,isLazyLoading)
{
  // Register apex.item callbacks
  apex.jQuery(pSelector).each(function(){
    apex.widget.initPageItem(this.id, {
      setValue      : function(pValue, pDisplayValue) {
        if (pValue.length == 0) { 
          $('#' + this.id).select2('data',null);
        } else {
          if(isLazyLoading) {
             var ajaxRequest = new htmldb_Get(null, $v('pFlowId'),request, $v('pFlowStepId'));
             ajaxRequest.addParam('x04',pValue);
             ajaxRequest.addParam('x06','GETDATA');
             var ajaxResult = JSON.parse(ajaxRequest.get());
             $('#' + this.id).select2('data',ajaxResult);
          } else {
             $('#' + this.id).val(pValue.split(':'));
          }
        }
      }
    });
  });
}

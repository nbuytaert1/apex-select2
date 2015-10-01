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
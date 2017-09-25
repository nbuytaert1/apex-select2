var beCtbSelect2 = {};

beCtbSelect2.events = {
  bind: function (pItem, pIsIgItem) {
    var pageItem = $("" + pItem + "");
    var igRegionId;

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

    if (pIsIgItem) {
      $(window).load(function() {
        igRegionId = apex.region.findClosest(pItem).element[0].id;
        apex.jQuery("#" + igRegionId).on('interactivegridselectionchange', function(e) {
          pageItem.trigger("change");
        });
      });
    }
  }
};
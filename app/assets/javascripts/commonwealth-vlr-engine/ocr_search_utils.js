/* various utilities for ocr search results display in Bootstrap modal and WDL-Viewer contexts */

/* pagination links should preserve the modal rather than reloading the page */
var top_pagination_selector = '#ocr_search_details .page_links a';
var bottom_pagination_selector = '#ocr_pagination #pagination_links a';
$(top_pagination_selector + ", " + bottom_pagination_selector).on("click", Blacklight.ajaxModal.modalAjaxLinkClick);

/* if the window is displayed in the WDL-Viewer context, page links should trigger page changes via JS */
if ($("body.wdl-viewer").length) {
    $(".book_page_link").on("click", function () {
        $('#ajax-modal').modal('hide');
        $viewer.trigger("goto-page-search",
            [1, this.href.match(/\d+$/), this.href.match(/ocr_q=[\S]+\#/)[0].replace('ocr_q=','').slice(0, -1)]);
        return false;
    });
}

/* so search queries entered by user don't accidentally trigger WDL-Viewer keyboard-based controls */
$('#ocr_q').on('keydown', function (e) {
    // Avoid keys bubbling up to our top-level input handler:
    e.stopPropagation();
});
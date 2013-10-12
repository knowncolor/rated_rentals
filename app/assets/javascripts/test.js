jQuery(document).ready(function() {
    $('#aaa').keyup(function () {
        var left = 140 - $(this).val().length;
        if (left < 0) {
            left = 0;
        }
        $('#counter').text('Characters left: ' + left);
    });
});

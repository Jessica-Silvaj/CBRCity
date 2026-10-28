$(window).on("load", function () {
  if (window.invokeNative) {
    var phoneWrapper = $("#lb-phone-weazel");
    var app = phoneWrapper.find(".app");

    app.insertBefore(phoneWrapper);
    phoneWrapper.remove();
    return;
  }
  $("#lb-phone-weazel").css("display", "block");
  $("body").css("visibility", "visible");
  var center = function () {
    $("#lb-phone-weazel").css(
      "transform",
      "scale(" + window.innerWidth / 1920 + ")"
    );
  };
  center();
  $(window).on("resize", center);
});

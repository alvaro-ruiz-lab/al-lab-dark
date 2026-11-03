// Unity WebGL plugin: functions callable from C# through [DllImport("__Internal")].
mergeInto(LibraryManager.library, {
  LumenShowToast: function (messagePtr, durationMs) {
    var message = UTF8ToString(messagePtr);
    var toast = document.createElement("div");
    toast.className = "lumen-toast";
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(function () { toast.remove(); }, durationMs || 2000);
  },

  LumenGetLocale: function () {
    var locale = navigator.language || "en-US";
    var size = lengthBytesUTF8(locale) + 1;
    var buffer = _malloc(size);
    stringToUTF8(locale, buffer, size);
    return buffer;
  },

  LumenIsMobile: function () {
    return /Android|iPhone|iPad/i.test(navigator.userAgent) ? 1 : 0;
  },
});

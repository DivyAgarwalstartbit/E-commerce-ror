// Rails defaults
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"

// ✅ LOAD JQUERY FIRST (import then expose to window)
import $ from 'jquery';
window.$ = $;
window.jQuery = $;

// ✅ THEN LOAD legacy plugins with require() so they run after window.jQuery is set
require("../js/owl.carousel.min")
require("../js/jquery-ui.min")
require("../js/jquery.slicknav")
require("../js/jquery.magnific-popup.min")
require("../js/jquery.nicescroll.min")
require("../js/jquery.countdown.min")

// mixitup (ES module)
import mixitup from "mixitup"
window.mixitup = mixitup
// Main theme JS LAST
require("../js/main")

document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('input[type="number"]').forEach(input => {
    input.addEventListener('change', function () {
      this.closest('form').submit();
    });
  });
});

// Bootstrap (only once)
import "bootstrap"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// app/javascript/packs/ashion.js
import $ from 'jquery';
window.$ = $;
window.jQuery = $;


(function ($) {
  'use strict';

  // Function to initialize all UI components
  function initializeUI() {
    /*------------------
        Preloader
    --------------------*/
    $(".loader").fadeOut();
    $("#preloder").delay(200).fadeOut("slow");

    /*------------------
        Product filter
    --------------------*/
    $('.filter__controls li').off('click').on('click', function () {
      $('.filter__controls li').removeClass('active');
      $(this).addClass('active');
    });

    if ($('.property__gallery').length > 0) {
      const containerEl = document.querySelector('.property__gallery');
      mixitup(containerEl);
    }

    /*------------------
        Background Set
    --------------------*/
    $('.set-bg').each(function () {
      const bg = $(this).data('setbg');
      $(this).css('background-image', `url(${bg})`);
    });

    /*------------------
        Search Switch
    --------------------*/
    $(document).off('click', '.search-switch').on('click', '.search-switch', function () {
      $('.search-model').fadeIn(400);
    });

    $(document).off('click', '.search-close-switch').on('click', '.search-close-switch', function () {
      $('.search-model').fadeOut(400, function () {
        $('#search-input').val('');
      });
    });

    /*------------------
        Canvas Menu
    --------------------*/
    $(document).off('click', '.canvas__open').on('click', '.canvas__open', function () {
      $(".offcanvas-menu-wrapper").addClass("active");
      $(".offcanvas-menu-overlay").addClass("active");
    });

    $(document).off('click', '.offcanvas-menu-overlay, .offcanvas__close')
      .on('click', '.offcanvas-menu-overlay, .offcanvas__close', function () {
        $(".offcanvas-menu-wrapper").removeClass("active");
        $(".offcanvas-menu-overlay").removeClass("active");
      });

    /*------------------
        Navigation
    --------------------*/
    if ($(".header__menu").length > 0) {
      $(".header__menu").slicknav({
        prependTo: '#mobile-menu-wrap',
        allowParentLinks: true
      });
    }

    /*------------------
        Accordion Active
    --------------------*/
    $('.collapse').off('shown.bs.collapse').on('shown.bs.collapse', function () {
      $(this).prev().addClass('active');
    });
    $('.collapse').off('hidden.bs.collapse').on('hidden.bs.collapse', function () {
      $(this).prev().removeClass('active');
    });

    /*--------------------------
        Banner Slider
    ----------------------------*/
    if ($(".banner__slider").length > 0) {
      $(".banner__slider").owlCarousel({
        loop: true,
        margin: 0,
        items: 1,
        dots: true,
        smartSpeed: 1200,
        autoHeight: false,
        autoplay: true
      });
    }

    /*--------------------------
        Product Details Slider
    ----------------------------*/
    if ($(".product__details__pic__slider").length > 0) {
      $(".product__details__pic__slider").owlCarousel({
        loop: false,
        margin: 0,
        items: 1,
        dots: false,
        nav: true,
        navText: ["<i class='arrow_carrot-left'></i>", "<i class='arrow_carrot-right'></i>"],
        smartSpeed: 1200,
        autoHeight: false,
        autoplay: false,
        mouseDrag: false,
        startPosition: 'URLHash'
      }).on('changed.owl.carousel', function (event) {
        const indexNum = event.item.index + 1;
        const thumbs = document.querySelectorAll('.product__thumb a');
        thumbs.forEach(function (e) {
          e.classList.remove("active");
          if (e.hash.split("-")[1] == indexNum) e.classList.add("active");
        });
      });
    }

    /*------------------
        Magnific Popup
    --------------------*/
    if ($('.image-popup').length > 0) {
      $('.image-popup').magnificPopup({ type: 'image' });
    }

    /*------------------
        Nice Scroll
    --------------------*/
    if ($(".nice-scroll").length > 0) {
      $(".nice-scroll").niceScroll({
        cursorborder: "",
        cursorcolor: "#dddddd",
        boxzoom: false,
        cursorwidth: 5,
        background: 'rgba(0, 0, 0, 0.2)',
        cursorborderradius: 50,
        horizrailenabled: false
      });
    }

    /*------------------
        Countdown
    --------------------*/
    if ($("#countdown-time").length) {
      const targetDate = new Date();
      targetDate.setMonth(targetDate.getMonth() + 1);

      $("#countdown-time").countdown(targetDate, function () {
        $(this).html(
          "<div class='countdown__item'><span>%D</span><p>Days</p></div>" +
          "<div class='countdown__item'><span>%H</span><p>Hours</p></div>" +
          "<div class='countdown__item'><span>%M</span><p>Mins</p></div>" +
          "<div class='countdown__item'><span>%S</span><p>Secs</p></div>"
        );
      });
    }

    /*-------------------
        Range Slider
    ---------------------*/
    if ($(".price-range").length > 0) {
      const rangeSlider = $(".price-range"),
        minamount = $("#minamount"),
        maxamount = $("#maxamount"),
        minPrice = rangeSlider.data('min'),
        maxPrice = rangeSlider.data('max');

      rangeSlider.slider({
        range: true,
        min: minPrice,
        max: maxPrice,
        values: [minPrice, maxPrice],
        slide: function (event, ui) {
          minamount.val('$' + ui.values[0]);
          maxamount.val('$' + ui.values[1]);
        }
      });
      minamount.val('$' + rangeSlider.slider("values", 0));
      maxamount.val('$' + rangeSlider.slider("values", 1));
    }

    /*------------------
        Single Product Image Switch
    --------------------*/
    $(document).off('click', '.product__thumb .pt').on('click', '.product__thumb .pt', function () {
      const imgurl = $(this).data('imgbigurl');
      const bigImg = $('.product__big__img').attr('src');
      if (imgurl !== bigImg) $('.product__big__img').attr({ src: imgurl });
    });

    /*-------------------
        Quantity change
    --------------------- */
    const proQty = $('.pro-qty');
    if (proQty.length > 0) {
      proQty.prepend('<span class="dec qtybtn">-</span>');
      proQty.append('<span class="inc qtybtn">+</span>');
    }

    $(document).off('click', '.qtybtn').on('click', '.qtybtn', function () {
      const $button = $(this);
      const oldValue = $button.parent().find('input').val();
      const newVal = $button.hasClass('inc') ? parseFloat(oldValue) + 1 : Math.max(parseFloat(oldValue) - 1, 0);
      $button.parent().find('input').val(newVal);
    });

    /*-------------------
        Radio Btn
    --------------------- */
    $(document).off('click', '.size__btn label').on('click', '.size__btn label', function () {
      $(".size__btn label").removeClass('active');
      $(this).addClass('active');
    });
  }

  // Run on both initial page load AND Turbolinks navigation
  $(document).on('turbolinks:load', initializeUI);

})(jQuery);

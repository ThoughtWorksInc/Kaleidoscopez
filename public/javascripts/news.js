var MilliSecPerSlide = 2000;
var radiusOfSlideCircle = 6000;

function autoScroll() {
    impress().next();
    setTimeout(autoScroll, MilliSecPerSlide);
}

function convertToRadians(degrees) {
    return degrees * Math.PI / 180;
}

function setupDisplay() {
    var impressDiv = $("#impress");

    function getXCoOrdinate(theta) {
        return radiusOfSlideCircle * Math.cos(convertToRadians(theta));
    }

    function getYCoOrdinated(theta) {
        return radiusOfSlideCircle * Math.sin(convertToRadians(theta));
    }

    function setupSlides(response) {
        for (var slideIndex = 0; slideIndex < response.length; slideIndex++) {
            var title = $('<div>');
            title.append(response[slideIndex]["title"])
            title.addClass("title");

            var source = $('<div>')
            source.append("-Hacker News") ;
            source.addClass("source");


            var slide = $('<div>');
            slide.addClass('step');
            slide.addClass('slide');

            var theta = (359 * slideIndex) / response.length;

            slide[0].setAttribute('data-x', getXCoOrdinate(theta));
            slide[0].setAttribute('data-y', getYCoOrdinated(theta));
            slide[0].setAttribute('data-rotate-z', theta);
            slide[0].setAttribute('data-rotate-x', slideIndex * 90);

            slide.append(title);
            slide.append(source);
            impressDiv.append(slide);
        }
    }

    $.ajax({
        url:'/all_news',
        dataType:'json',
        success:function (response) {
            setupSlides(response);
            impress().init();
            setTimeout(autoScroll, 2000);
        }
    })

}
$(document).ready(function () {
    setupDisplay();
})
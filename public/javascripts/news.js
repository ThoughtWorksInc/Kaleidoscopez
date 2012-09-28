var milliSecPerSlide = 5000;

function autoScroll() {
    impress().next();
    var hue = (Math.random()*360).toFixed();
    var saturation = (Math.random() * 100).toFixed();
    var value = 80 + (Math.random() * 20).toFixed();
    var hsvColor = {h: hue, s: saturation, v: value};
    $('body').css('background-color', tinycolor(hsvColor).toRgbString() )
}

function convertToRadians(degrees) {
    return degrees * Math.PI / 180;
}

function setupDisplay() {
    var impressDiv = $("#impress");

    function setupSlides(response) {
        var items = response["items"];
        var totalNoOfItems = items.length;
        var radiusOfSlideCircle = totalNoOfItems * 100;

        function calcRotationAngle(itemIndex) {
            return (359 * itemIndex) / totalNoOfItems;     //Some issue with 360, 359 works ! JS Sucks at Math >_<
        }

        function getXCoOrdinate(theta) {
            return radiusOfSlideCircle * Math.cos(convertToRadians(theta));
        }

        function getYCoOrdinate(theta) {
            return radiusOfSlideCircle * Math.sin(convertToRadians(theta));
        }

        function prepareTitle(item) {
            var title = $('<div>');
            title.append(item["title"])
            title.addClass("title");
            return title;
        }

        function prepareSource(item) {
            var source = $('<div>');
            source.append(item["source"]);
            source.addClass("source");
            return source;
        }

        function prepareAuthor(item) {
            var author = $('<div>');
            author.append(item["author"])
            author.addClass("author");
            return author;
        }

        function prepareEmptySlide() {
            var slide = $('<div>');
            slide.addClass('step');
            slide.addClass('slide');
            return slide;
        }

        function setupRotationOfSlide(slide, itemIndex) {
            var theta = calcRotationAngle(itemIndex);
            slide.setAttribute('data-x', getXCoOrdinate(theta));
            slide.setAttribute('data-y', getYCoOrdinate(theta));
            slide.setAttribute('data-rotate-z', theta);
            slide.setAttribute('data-rotate-x', itemIndex * 90);
        }

        function assembleSlide() {
            slide.append(title);
            slide.append(source);
            slide.append(author);
            impressDiv.append(slide);
        }

        for(var itemIndex = 0; itemIndex < totalNoOfItems; itemIndex++){

            var item = items[itemIndex];

            var title = prepareTitle(item);
            var author = prepareAuthor(item);
            var source = prepareSource(item);
            var slide = prepareEmptySlide();

            setupRotationOfSlide(slide[0], itemIndex);
            assembleSlide();
        }

    }

    $.ajax({
        url:'/all_news',
        dataType:'json',
        success: function(response) {
            setupSlides(response);
            impress().init();
        }
    })
}
function startup() {
    setInterval(autoScroll, milliSecPerSlide);
    setupDisplay();
}

$(document).ready(function () {
    startup();
})
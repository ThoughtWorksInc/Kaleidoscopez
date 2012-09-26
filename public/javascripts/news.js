var milliSecPerSlide = 5000;

function autoScroll() {
    impress().next();
    var hue = (Math.random()*360).toFixed();
    var saturation = (Math.random()*100).toFixed();
    var value = 80 + (Math.random()*20).toFixed();
    var hsvColor = {h: hue ,s: saturation,v: value};
    $('body').css('background-color',tinycolor(hsvColor).toRgbString() )
}

function convertToRadians(degrees) {
    return degrees * Math.PI / 180;
}

function setupDisplay() {
    var impressDiv = $("#impress");

    function setupSlides(response) {
        var feeds = response["feeds"];
        var sources = response["sources"];
        var totalNoOfFeeds = feeds.length;
        var radiusOfSlideCircle = totalNoOfFeeds*100;

        function calcRotationAngle(feedIndex) {
            return (359 * feedIndex) / totalNoOfFeeds;     //Some issue with 360, 359 works ! JS Sucks at Math >_<
        }

        function getXCoOrdinate(theta) {
            return radiusOfSlideCircle * Math.cos(convertToRadians(theta));
        }

        function getYCoOrdinate(theta) {
            return radiusOfSlideCircle * Math.sin(convertToRadians(theta));
        }

        function prepareTitle() {
            var title = $('<div>');
            title.append(feed["title"])
            title.addClass("title");
            return title;
        }

        function prepareSource(source_id) {
            var source = $('<div>');
            source.append(sources[source_id]);
            source.addClass("source");
            return source;
        }

        function prepareAuthor(source_id) {
            var author = $('<div>');
            author.append(feed["author"])
            author.addClass("author");
            return author;
        }

        function prepareEmptySlide() {
            var slide = $('<div>');
            slide.addClass('step');
            slide.addClass('slide');
            return slide;
        }

        function setupRotationOfSlide(slide, feedIndex) {
            var theta = calcRotationAngle(feedIndex);
            slide.setAttribute('data-x', getXCoOrdinate(theta));
            slide.setAttribute('data-y', getYCoOrdinate(theta));
            slide.setAttribute('data-rotate-z', theta);
            slide.setAttribute('data-rotate-x', feedIndex * 90);
        }

        function assembleSlide() {
            slide.append(title);
            slide.append(source);
            slide.append(author);
            impressDiv.append(slide);
        }

        for(var feedIndex=0; feedIndex< totalNoOfFeeds; feedIndex++){

            var feed = feeds[feedIndex];

            var title = prepareTitle();
            var author = prepareAuthor();
            var source = prepareSource(feed["feed_source_id"]);
            var slide = prepareEmptySlide();

            setupRotationOfSlide(slide[0], feedIndex);
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
var milliSecPerSlide = 5000;
var radiusOfSlideCircle = 6000;

function autoScroll() {
    impress().next();
    setTimeout(autoScroll, milliSecPerSlide);
}

function convertToRadians(degrees) {
    return degrees * Math.PI / 180;
}

function setupDisplay() {
    var impressDiv = $("#impress");

    function setupSlides(response) {
        var totalFeedIndex = 0;
        var totalNoOfFeeds = calcTotalNoOfFeeds();
        radiusOfSlideCircle = totalNoOfFeeds*100;

        function calcTotalNoOfFeeds(){
            var someVar=0
            for(var sourceIndex = 0; sourceIndex< response.length; sourceIndex++){
                someVar+=response[sourceIndex]["feeds"].length;
            }
            return someVar
        }

        function calcRotationAngle(totalFeedIndex) {
            return (359 * totalFeedIndex) / totalNoOfFeeds;     //Some issue with 360, 359 works ! JS Sucks at Math >_<
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

        function prepareSource(feedSource) {
            var source = $('<div>');
            source.append(feedSource["name"]);
            source.addClass("source");
            return source;
        }

        function prepareEmptySlide() {
            var slide = $('<div>');
            slide.addClass('step');
            slide.addClass('slide');
            return slide;
        }

        function setupRotationOfSlide(slide,feedIndex,totalFeedIndex) {
            var theta = calcRotationAngle(totalFeedIndex);
            slide.setAttribute('data-x', getXCoOrdinate(theta));
            slide.setAttribute('data-y', getYCoOrdinate(theta));
            slide.setAttribute('data-rotate-z', theta);
            slide.setAttribute('data-rotate-x', feedIndex * 90);
        }

        function assembleSlide() {
            slide.append(title);
            slide.append(source);
            impressDiv.append(slide);
        }

        for (var sourceIndex = 0; sourceIndex < response.length; sourceIndex++) {
            var feedSource = response[sourceIndex];

            for(var feedIndex=0; feedIndex< feedSource["feeds"].length; feedIndex++){
                var feed = feedSource["feeds"][feedIndex];

                var title = prepareTitle();
                var source = prepareSource(feedSource);
                var slide = prepareEmptySlide();

                setupRotationOfSlide(slide[0],feedIndex,totalFeedIndex);
                assembleSlide();

                totalFeedIndex++;
            }
        }
    }

    $.ajax({
        url:'/all_news',
        dataType:'json',
        success:function (response) {
            setupSlides(response);
            impress().init();
            setTimeout(autoScroll, milliSecPerSlide);
        }
    })

}
$(document).ready(function () {
    setupDisplay();
})
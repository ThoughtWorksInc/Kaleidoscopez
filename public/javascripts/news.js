var milliSecPerSlide = 15000;

function autoScroll() {
    impress().next();
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
            title.append(item["title"]) ;
            if(item['image'] == null && (item['summary'] == "" || item['summary'] == null)) {
                title.addClass('title-without-content');
            }else {
                title.addClass("title-with-content");
            }
            return title;
        }

        function prepareDate(item) {
            var date = $('<div>');
            date.append(moment(item["date"]).fromNow());
            date.addClass("date");
            return date;
        }

        function prepareSource(item) {
            var source = $('<div>');
            source.append("via " + item["source"]);
            source.addClass("source");
            return source;
        }

        function prepareAuthor(item) {
            function prepare_author_image(author_div) {
                var author_image = $('<img>');
                author_image.attr('src', item['author_image']);
                if (item['author_image']) author_div.append(author_image);
            }

            function prepare_author_name(author_div) {
                author_div.append($('<div>').addClass('author-name').append(item["author"]));
                author_div.addClass("author");
            }
            var author = $('<div>');

            var footer=$('<div>');
            footer.addClass('footer');
            prepare_author_image(author);
            prepare_author_name(author);
            footer.append(author);
            footer.append(source);
            return footer;
        }

        function prepareImage(item) {
            if(item['image']){
                var image_div = $('<div>');
                var img = $('<img>');
                img.attr('src',item['image']);
                image_div.append(img);
                if(item['summary'] == "" || item['summary'] == null)
                    image_div.addClass("image-without-summary");
                else
                    image_div.addClass("image-with-summary");
                return image_div;
            }
        }

        function prepareSummary(item) {
            if(item['summary']){
                var summary = $('<div>');
                summary.append(item['summary']);
                summary.addClass("summary");
                return summary;
            }
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
            slide.setAttribute('data-rotate-x', itemIndex * 88);
            slide.setAttribute('data-rotate-z', theta);
        }
        function assembleSlide() {
            slide.append(title);
            slide.append(image);
            slide.append(summary);
            slide.append(author);
            $(author).find('.author').append(date);
            impressDiv.append(slide);
        }
        for(var itemIndex = 0; itemIndex < totalNoOfItems; itemIndex++){
            var item = items[itemIndex];
            var title = prepareTitle(item);
            var summary = prepareSummary(item);
            var image = prepareImage(item);
            var source = prepareSource(item);
            var author = prepareAuthor(item);
            var date = prepareDate(item);
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
});
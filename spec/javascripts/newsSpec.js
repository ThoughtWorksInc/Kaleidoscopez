function mockMoment(items){
    function moment_for_first_item(){
        this.fromNow = function(){
            return "20 minutes ago"
        }
    }
    function moment_for_second_item(){
        this.fromNow = function(){
            return "a few seconds ago"
        }
    }
    window.moment = function (date){
        if(date == items[0]["date"]) return new moment_for_first_item
        if(date == items[1]["date"]) return new moment_for_second_item
    }
}

describe("news", function(){


    beforeEach(function(){


        impress = function(){
            return {
                init: function(){},
                next: function(){},
                pre: function(){}
            }
        }

    })
    describe("should setup display", function(){

        var response = {
            items: [
                {
                    title: "item1_title_without_author_image",
                    author: "item1_author",
                    source: "abcd",
                    date: "2012-10-08T04:00:00Z",
                    image: "image1",
                    summary: "this is dummy content"
                },
                {
                    title: "item2_title",
                    author: "item2_author",
                    author_image: "item2_author_image",
                    source: "pqrs",
                    date: "2012-10-08T05:00:00Z",
                    image: "image2",
                    summary: "this is dummy content 2"
                } ,
                {
                    title: "item3_title_without_image",
                    author: "item3_author",
                    author_image: "item3_author_image",
                    source: "pqrs",
                    date: "2012-10-08T05:00:00Z"
                },
                {
                    title: "item4_without_summary",
                    author: "item4_author",
                    author_image: "item4_author_image",
                    source: "pqrs",
                    date: "2012-10-08T05:00:00Z",
                    image: "image4"
                }
            ]
        };

        beforeEach(function(){
            spyOn($,'ajax').andCallFake(function(params){
                params.success(response);
            })

            setupDisplay();
        })

        it("should fire an ajax request and hit /all_news to get json",function(){
            expect($.ajax).toHaveBeenCalledWith({
                url: "/all_news",
                dataType: "json",
                success: jasmine.any(Function)
            });
        })
        describe("should setup slides", function(){
            var impressDiv=false;
            var steps = false;
            var items = response["items"];

            beforeEach(function(){
                impressDiv = $("<div>");
                impressDiv.attr("id","impress");
                $('body').append(impressDiv);
                mockMoment(items);
                setupDisplay();
                steps = impressDiv.find('.step');
            })

            it("should create all slides", function(){
                expect(steps.length).toBe(response["items"].length);
            })

            it("should create slides with title at the top when image is present", function(){
                expect($(steps[0]).find('.title-with-image').html()).toBe(items[0]["title"]);
                expect($(steps[1]).find('.title-with-image').html()).toBe(items[1]["title"]);
            })

            it("should position title at the centre of slide when there is no image", function(){
                expect($(steps[2]).find('.title-no-image').length).toBe(1);
            })

            it("should create all slides with date", function() {
                expect($(steps[0]).find('.date').html()).toBe("20 minutes ago");
                expect($(steps[1]).find('.date').html()).toBe("a few seconds ago");
            })

            it("should create all slides with source",function(){
                expect($(steps[0]).find('.source').html()).toBe("via " + items[0]["source"]);
                expect($(steps[1]).find('.source').html()).toBe("via " + items[1]["source"]);
            })

            it("should create all slides with author",function(){
                expect($(steps[0]).find('.author .author-name').html()).toBe(items[0]["author"]);
                expect($(steps[1]).find('.author .author-name').html()).toBe(items[1]["author"]);
            })

            it("should create all slides with image if image exists",function(){
                expect($(steps[0]).find('.image-with-summary img').attr('src')).toBe(items[0]["image"]);
                expect($(steps[1]).find('.image-with-summary img').attr('src')).toBe(items[1]["image"]);
            })

            it("should create all slides with summary if summary exists",function(){
                expect($(steps[0]).find('.summary').html()).toBe(items[0]["summary"]);
                expect($(steps[1]).find('.summary').html()).toBe(items[1]["summary"]);
            })

            it("should position image at the centre of slide when there is no summary", function(){
                expect($(steps[3]).find('.image-without-summary img').length).toBe(1);
            })

            it("should create slide without summary if it does not exist", function(){
                expect($(steps[2]).find('.image-with-summary img').length).toBe(0);
            })

            it("should create slide without image if image does not exist",function(){
                expect($(steps[2]).find('.image-with-summary img').length).toBe(0);
            })

            it("should create slides without author image, if it does not exists", function(){
                expect($(steps[0]).find('.author img').length).toBe(0)
            })

            it("should create slides with author image, if it exists", function(){
                expect($(steps[1]).find('.author img').attr('src')).toBe(items[1]["author_image"])
            })

            it("should set all slides to rotate", function(){
               for(var i = 0; i < steps.length; i++){
                   var expected_theta_degrees = 359 * i / steps.length;
                   var expected_theta_radians = (expected_theta_degrees) * Math.PI / 180;
                   var expected_radius = steps.length * 100;
                   var expected_data_x = expected_radius*Math.cos(expected_theta_radians);
                   var expected_data_y = expected_radius*Math.sin(expected_theta_radians);
                   expect(parseFloat($(steps[i]).attr('data-x'))).toBe(expected_data_x);
                   expect(parseFloat($(steps[i]).attr('data-y'))).toBe(expected_data_y);
                   expect(parseFloat($(steps[i]).attr('data-rotate-z'))).toBe(expected_theta_degrees);
                   expect(parseFloat($(steps[i]).attr('data-rotate-x'))).toBe(i * 88);
               }
            })

            afterEach(function(){
                impressDiv.remove();
            })
        })
    })

    it("should convert degrees to radians", function(){
        expect(convertToRadians(180).toPrecision(3)).toBe('3.14')
    })

    describe("should autoscroll",function(){
        beforeEach(function(){
            spyOn(window,'autoScroll').andCallThrough();
            jasmine.Clock.useMock();
            startup()
        })

        it("should call autoScroll function periodically", function(){

            jasmine.Clock.tick(milliSecPerSlide);
            expect(autoScroll.callCount).toEqual(1);

            jasmine.Clock.tick(milliSecPerSlide);
            expect(autoScroll.callCount).toEqual(2);
        })


    });

})

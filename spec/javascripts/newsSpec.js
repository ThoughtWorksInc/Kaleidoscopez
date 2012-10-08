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
                    title: "item1_title",
                    url: "item1_url",
                    author: "item1_author",
                    source: "abcd",
                    date: "2012-09-29",
                    image: "image1"
                },
                {
                    title: "item2_title",
                    url: "item2_url",
                    author: "item2_author",
                    author_image: "item2_author_image",
                    source: "pqrs",
                    date: "2011-09-29",
                    image: "image2"
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
                setupDisplay();
                steps = impressDiv.find('.step');
            })

            it("should create all slides", function(){
                expect(steps.length).toBe(response["items"].length);
            })

            it("should create all slides with title", function(){
                expect($(steps[0]).find('.title').html()).toBe(items[0]["title"]);
                expect($(steps[1]).find('.title').html()).toBe(items[1]["title"]);
            })

            it("should create all slides with date", function() {
                expect($(steps[0]).find('.date').html()).toBe(items[0]["date"]);
                expect($(steps[1]).find('.date').html()).toBe(items[1]["date"]);
            })

            it("should create all slides with source",function(){
                expect($(steps[0]).find('.source').html()).toBe(items[0]["source"]);
                expect($(steps[1]).find('.source').html()).toBe(items[1]["source"]);
            })

            it("should create all slides with author",function(){
                expect($(steps[0]).find('.author .author_name').html()).toBe(items[0]["author"]);
                expect($(steps[1]).find('.author .author_name').html()).toBe(items[1]["author"]);
            })

            it("should create all slides with image",function(){
                expect($(steps[0]).find('.image img').attr('src')).toBe(items[0]["image"]);
                expect($(steps[1]).find('.image img').attr('src')).toBe(items[1]["image"]);
            })

            it("should create slides with author image, if it exists", function(){
                expect($(steps[0]).find(' .author img').length).toBe(0)
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
                   expect(parseFloat($(steps[i]).attr('data-rotate-x'))).toBe(i * 90);
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

        it("should change body color",function(){
            var original_body_color = $('body').css('background-color');
            jasmine.Clock.tick(milliSecPerSlide);
            expect($('body').css('background-color')).not.toBe(original_body_color);
        })
    });

})
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
            feeds: [
                {
                    title: "feed1_title",
                    url: "feed1_url",
                    author: "feed1_author",
                    feed_source_id: "abcd"
                },
                {
                    title: "feed2_title",
                    url: "feed2_url",
                    author: "feed2_author",
                    feed_source_id: "pqrs"
                }
            ],
            sources: {
                abcd: "source_abcd",
                pqrs: "source_pqrs"
            }
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
            beforeEach(function(){
                impressDiv = $("<div>");
                impressDiv.attr("id","impress");
                $('body').append(impressDiv);
                setupDisplay();
                steps = impressDiv.find('.step');
            })

            it("should create all slides", function(){
                expect(steps.length).toBe(response["feeds"].length);
            })

            it("should create all slides with title", function(){
                for(var i=0;i<steps.length;i++){
                    var expectedFeedTitle = response["feeds"][i]["title"];
                    expect($(steps[i]).find('.title').html()).toBe(expectedFeedTitle);
                }
            })

            it("should create all slides with source",function(){
                for(var i=0;i<steps.length;i++){
                    var feedSourceId = response["feeds"][i]["feed_source_id"];
                    var expectedFeedSource = response["sources"][feedSourceId];
                    expect($(steps[i]).find('.source').html()).toBe(expectedFeedSource);
                }
            })

            it("should create all slides with author",function(){
                for(var i=0;i<steps.length;i++){
                    var expectedFeedAuthor = response["feeds"][i]["author"];
                    expect($(steps[i]).find('.author').html()).toBe(expectedFeedAuthor);
                }
            })

            it("should set all slides to rotate", function(){
               for(var i=0;i<steps.length;i++){
                   var expected_theta_degrees = 359*i/steps.length;
                   var expected_theta_radians = (expected_theta_degrees)*Math.PI/180;
                   var expected_radius = steps.length * 100;
                   var expected_data_x = expected_radius*Math.cos(expected_theta_radians);
                   var expected_data_y = expected_radius*Math.sin(expected_theta_radians);

                   expect(parseFloat($(steps[i]).attr('data-x'))).toBe(expected_data_x);
                   expect(parseFloat($(steps[i]).attr('data-y'))).toBe(expected_data_y);
                   expect(parseFloat($(steps[i]).attr('data-rotate-z'))).toBe(expected_theta_degrees);
                   expect(parseFloat($(steps[i]).attr('data-rotate-x'))).toBe(i*90);
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
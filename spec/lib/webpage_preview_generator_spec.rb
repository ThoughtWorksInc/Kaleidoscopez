require 'spec_helper'
require 'webpage_preview_generator'

describe WebpagePreviewGenerator, :imgkit => true do

  subject do
    WebpagePreviewGenerator.instance
  end

  it "should return item with webpage preview" do
    mock_imgkit = "mock imgkit"
    mock_image = "Mock jpg Image"

    IMGKit.should_receive(:new).with("test.url",quality: 50, width: 600).and_return(mock_imgkit)
    mock_imgkit.should_receive(:to_jpg).and_return(mock_image)

    expected_file = "public/images/preview/test_file"

    subject.generate("test_file", "test.url").should == "/images/preview/test_file"

    File.exists?(expected_file).should be true
    open(expected_file).read.should == mock_image

    File.delete expected_file
  end


  it "should not crash when IMGKit can't produce webpage preview" do
    IMGKit.any_instance.should_receive(:to_jpg).and_raise(RuntimeError.new("Test Exception"))

    subject.generate("test_name","test.url").should be nil
  end
end

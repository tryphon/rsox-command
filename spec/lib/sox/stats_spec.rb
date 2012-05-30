require 'spec_helper'

describe Sox::Stats do

  subject { Sox::Stats.new }

  let(:file) { "spec/fixtures/test.ogg" }
  
  describe "#raw_output" do
    
    it "should return sox command output" do
      subject.input(file)
      subject.raw_output.should == IO.read("spec/fixtures/test.stats")
    end

  end

  describe "cache" do

    it "should return sox command output" do
      # Fill cache
      Sox::Stats.new(file, :use_cache => true).attributes

      subject.use_cache = true
      subject.input(file)

      subject.command.should_not_receive(:run!)

      subject.attributes
    end

    after(:each) do
      FileUtils.rm_f "spec/fixtures/test.ogg.stats"
    end
                     
  end

  describe "#attributes" do
    
    it "should read name and first value from raw output" do
      subject.stub :raw_output => "A key in dB  -3"
      subject.attributes["A key in dB"].should == -3
    end

    it "should read standard sox output" do
      subject.stub :raw_output => IO.read("spec/fixtures/test.stats")
      subject.attributes.should == {
        "DC offset" => 0.000010,
        "Min level" =>  -1.0,
        "Max level" => 0.999969,
        "Pk lev dB" => 0.0,
        "RMS lev dB" => -2.98,
        "RMS Pk dB" => -2.91,
        "RMS Tr dB" => -3.06,
        "Crest factor" => "-",
        "Flat factor" => 6.70,
        "Pk count" => "37.8k",
        # "Bit-depth" => "16/16",
        "Num samples" => "664k",
        "Length s" => 15.050,
        "Scale max" =>  1.0,
        "Window s" => 0.050
      }
    end

  end

  describe "rms_level" do
    
    it "should return 'RMS lev dB' found by sox" do
      subject.stub :attributes => { 'RMS lev dB' => -3.0 }
      subject.rms_level.should == -3.0
    end

  end
                    
end

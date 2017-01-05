require_relative "../spec_helper"
require 'fileutils'

RSpec.describe UmnShibAuth do
  describe ".using_stub_internet_id?" do
    context "ENV[STUB_INTERNET_ID] is set and file is set properly" do
      before do
        ENV["STUB_INTERNET_ID"] = rand(1..999).to_s
        File.write(UmnShibAuth::ENABLE_STUB_FILE, "I Want To Stub", mode: "w+")
      end

      after do
        ENV.delete("STUB_INTERNET_ID")
        FileUtils.rm(UmnShibAuth::ENABLE_STUB_FILE)
      end

      it "returns true" do
        expect(described_class.using_stub_internet_id?).to be true
      end
    end

    context "ENV[STUB_INTERNET_ID] is set and file has the wrong text" do
      before do
        ENV["STUB_INTERNET_ID"] = rand(1..999).to_s
        File.write(UmnShibAuth::ENABLE_STUB_FILE, "Stubbing? Eh.", mode: "w+")
      end

      after do
        ENV.delete("STUB_INTERNET_ID")
        FileUtils.rm(UmnShibAuth::ENABLE_STUB_FILE)
      end

      it "returns false" do
        expect(described_class.using_stub_internet_id?).to be false
      end
    end

    context "ENV[STUB_INTERNET_ID] is set and file has the correct text with a trailing newline" do
      before do
        ENV["STUB_INTERNET_ID"] = rand(1..999).to_s
        File.write(UmnShibAuth::ENABLE_STUB_FILE, "I Want To Stub\n", mode: "w+")
      end

      after do
        ENV.delete("STUB_INTERNET_ID")
        FileUtils.rm(UmnShibAuth::ENABLE_STUB_FILE)
      end

      it "returns true" do
        expect(described_class.using_stub_internet_id?).to be true
      end
    end

    context "ENV[STUB_INTERNET_ID] is set and file is NOT set" do
      before do
        ENV["STUB_INTERNET_ID"] = rand(1..999).to_s
        FileUtils.rm(UmnShibAuth::ENABLE_STUB_FILE) if File.exist?(UmnShibAuth::ENABLE_STUB_FILE)
      end

      after do
        ENV.delete("STUB_INTERNET_ID")
      end

      it "returns false" do
        expect(described_class.using_stub_internet_id?).to be false
      end
    end

    context "ENV[STUB_INTERNET_ID] is not set and file is set" do
      before do
        ENV.delete("STUB_INTERNET_ID")
        File.write(UmnShibAuth::ENABLE_STUB_FILE, "I Want To Stub", mode: "w+")
      end

      after do
        FileUtils.rm(UmnShibAuth::ENABLE_STUB_FILE) if File.exist?(UmnShibAuth::ENABLE_STUB_FILE)
      end

      it "returns false" do
        expect(described_class.using_stub_internet_id?).to be false
      end
    end
  end
end

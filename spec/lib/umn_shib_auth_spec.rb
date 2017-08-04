require_relative "../spec_helper"
require 'fileutils'
require 'securerandom'

RSpec.describe UmnShibAuth do
  let(:internet_id)  { SecureRandom.hex[0, 8] }
  let(:emplid)       { rand(10**7).to_s.rjust(7, '0') }
  let(:display_name) { SecureRandom.hex }

  describe '.set_global_defaults!' do
    it 'set values correctly' do
      described_class.set_global_defaults!
      expect(described_class.eppn_variable).to eq('eppn')
      expect(described_class.emplid_variable).to eq('umnEmplId')
      expect(described_class.display_name_variable).to eq('displayName')
    end
  end

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

  context "with set stub environment values" do
    before do
      ENV["STUB_INTERNET_ID"] = internet_id
      ENV["STUB_EMPLID"] = emplid
      ENV["STUB_DISPLAY_NAME"] = display_name
    end

    after do
      ENV.delete("STUB_INTERNET_ID")
      ENV.delete("STUB_EMPLID")
      ENV.delete("STUB_DISPLAY_NAME")
    end

    describe ".stub_internet_id" do
      context "file is not set properly" do
        before do
          FileUtils.rm(UmnShibAuth::ENABLE_STUB_FILE) if File.exist?(UmnShibAuth::ENABLE_STUB_FILE)
        end

        it "raises an error" do
          expect { described_class.stub_internet_id }.to raise_error(UmnShibAuth::StubbingNotEnabled)
        end
      end

      context "file is set properly" do
        before do
          File.write(UmnShibAuth::ENABLE_STUB_FILE, "I Want To Stub", mode: "w+")
        end

        after do
          FileUtils.rm(UmnShibAuth::ENABLE_STUB_FILE)
        end

        it "returns stub internet id" do
          expect(described_class.stub_internet_id).to eq(internet_id)
        end
      end
    end

    describe ".stub_emplid" do
      context "file is not set properly" do
        before do
          FileUtils.rm(UmnShibAuth::ENABLE_STUB_FILE) if File.exist?(UmnShibAuth::ENABLE_STUB_FILE)
        end

        it "raises an error" do
          expect { described_class.stub_emplid }.to raise_error(UmnShibAuth::StubbingNotEnabled)
        end
      end

      context "file is set properly" do
        before do
          File.write(UmnShibAuth::ENABLE_STUB_FILE, "I Want To Stub", mode: "w+")
        end

        after do
          FileUtils.rm(UmnShibAuth::ENABLE_STUB_FILE)
        end

        it "returns stub internet id" do
          expect(described_class.stub_emplid).to eq(emplid)
        end

        context "with blank stub emplid" do
          before do
            ENV.delete("STUB_EMPLID")
          end

          it "does not throw an error" do
            expect { described_class.stub_emplid }.not_to raise_error
          end

          it "returns nil" do
            expect(described_class.stub_emplid).to be_nil
          end
        end
      end
    end

    describe ".stub_display_name" do
      context "file is not set properly" do
        before do
          FileUtils.rm(UmnShibAuth::ENABLE_STUB_FILE) if File.exist?(UmnShibAuth::ENABLE_STUB_FILE)
        end

        it "raises an error" do
          expect { described_class.stub_display_name }.to raise_error(UmnShibAuth::StubbingNotEnabled)
        end
      end

      context "file is set properly" do
        before do
          File.write(UmnShibAuth::ENABLE_STUB_FILE, "I Want To Stub", mode: "w+")
        end

        after do
          FileUtils.rm(UmnShibAuth::ENABLE_STUB_FILE)
        end

        it "returns stub display name" do
          expect(described_class.stub_display_name).to eq(display_name)
        end

        context "with blank stub display_name" do
          before do
            ENV.delete("STUB_DISPLAY_NAME")
          end

          it "does not throw an error" do
            expect { described_class.stub_display_name }.not_to raise_error
          end

          it "returns nil" do
            expect(described_class.stub_display_name).to be_nil
          end
        end
      end
    end
  end
end

require_relative './spec_helper'

RSpec.describe "EPPN Override" do
  let(:eppn_var) { "HTTP_EPPN" }
  let(:internet_id) { "rand#{rand(1000)}" }
  let(:eppn) { "#{internet_id}@blah.edu" }
  let(:controller) { DummyController.new }
  let(:env_stub) { instance_double(ActionDispatch::Request) }

  before do
    UmnShibAuth.eppn_variable = eppn_var
    allow(env_stub).to receive(:env).and_return({ eppn_var => eppn })
    allow(controller).to receive(:request).and_return(env_stub)
  end

  it "should run" do
    expect(controller.shib_umn_session.internet_id).to eq(internet_id)
  end
end

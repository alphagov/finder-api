Before('@stub_panopticon') do
  require 'panopticon_registerer'
  @fake_panopticon = double("panopticon")

  allow(@fake_panopticon).to receive(:register)
  allow(GdsApi::Panopticon::Registerer).to receive(:new).and_return(@fake_panopticon)
end

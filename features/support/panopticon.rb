
Before('@stub_panopticon_registerer') do
  require 'panopticon_registerer'

  allow(PanopticonRegisterer).to receive(:register)
end
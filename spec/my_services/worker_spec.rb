RSpec.describe MyServices::Worker do
  let(:worker) { described_class.new(params) }
  describe "#save" do
    subject { -> { worker.save } }

    context "ID" do
      before { expect(params[:id]).to be }
    end
  end
end


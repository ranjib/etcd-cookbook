require 'chefspec'

describe "etcd::default" do
  let(:runner) do
    ChefSpec::ChefRunner.new.converge('recipe[etcd]')
  end

  it "should run at least :-)" do
    expect(runner).to_not be_nil
  end
end

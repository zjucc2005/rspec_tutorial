describe "outer" do
    before(:each) { puts "1 - outer before" }
    describe "inner" do
        before(:each) { puts "2 - inner before" }
        it { puts "3 - test example"}
        after(:each) { puts "4 - inner after" }
    end
    after(:each) { puts "5 - outer after" }
end
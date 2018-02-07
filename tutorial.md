### RSpec Tutorial

## Get Started
1. 安装RSpec
```
$ gem install rspec
```
2. 新建第一个测试用例文件hello_world_spec.rb, 写入下面的代码
```
class HelloWorld

   def say_hello
      "Hello World!"
   end

end

describe HelloWorld do
   context "When testing the HelloWorld class" do

      it "should say 'Hello World' when we call the say_hello method" do
         hw = HelloWorld.new
         message = hw.say_hello
         expect(message).to eq "Hello World!"
      end

   end
end
```
3. 运行hello_world_spec.rb
```
$ rspec hello_world_spec.rb
.

Finished in 0.00231 seconds (files took 0.18998 seconds to load)
1 example, 0 failures
```


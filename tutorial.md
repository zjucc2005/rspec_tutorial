# RSpec Tutorial

## 开始吧, 先来Hello World!
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

## 语法
1. 关键词 - 以上面的hello_world_spec.rb为例
```
# describe - 通常用来定义*一组测试用例*, describe的参数可以是类/字符串.
# 也可以写成 RSpec.describe HelloWorld{...}
describe HelloWorld do

   # context - 类似describe, 通常用来定义*一类测试用例*, context的参数可以是类/字符串.
   # 比如:
   # context "pass invalid params to User.new" {...}
   # context "pass valid params to my_method()" {...}
   # describe可以嵌套使用, 所以context用的相对较少
   context "When testing the HelloWorld class" do

      # it - 用来定义*一个测试用例*, it的参数可以是类/字符串, 目的在于*表述清楚指定行为的预期结果*
      # 英文表述,例 should do/return *expected behaviour/outcome* under/when *specified condition*
      # 中文表述,例 当*某种条件*时,应该*做预期的行为/返回预期的结果*
      it "should say 'Hello World' when we call the say_hello method" do
         hw = HelloWorld.new
         message = hw.say_hello
         expect(message).to eq "Hello World!"
      end

   end
end
```


